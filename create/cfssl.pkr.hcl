variable "repo" {
     type = string
  }

source "docker" "cfssl_builder" {
    image = "golang:alpine"
    commit = true
    changes = [
      "USER cfssl",
      "WORKDIR /",
      "EXPOSE 8888",
      "LABEL version=1.0",
      "ONBUILD RUN date",
      "ENTRYPOINT /entrypoint.sh"
    ]
}

build {
    sources = ["source.docker.cfssl_builder"]

    provisioner "shell" {
        inline = ["apk update && apk add --no-cache wget git gcc musl-dev make"]
    }

    provisioner "shell" {
        inline = ["mkdir -p /builddir && cd /builddir",
                  "git clone https://github.com/cloudflare/cfssl.git .",
                  "git clone https://github.com/cloudflare/cfssl_trust.git /etc/cfssl",
                  "CGO_ENABLED=0 && make clean",
                  "make bin/rice && ./bin/rice embed-go -i=./cli/serve",
                  "make all && cp bin/* /bin/"]
            
    }

    provisioner "shell" {
        inline = ["addgroup -S cfssl && adduser -S cfssl -G cfssl -H -h /",
                "mkdir -m777 /certs"]
    }

    provisioner "shell-local" {
        inline = ["./gen-apikey.sh"]
    }

    provisioner "file"{
        source = "./ca-csr.json"
        destination = "/certs/ca-csr.json"
        generated = true
    }

    provisioner "file"{
        source = "./ca-config.json"
        destination = "/certs/ca-config.json"
        generated = true
    }

    provisioner "file"{
        source = "./entrypoint.sh"
        destination = "/entrypoint.sh"
    }

    provisioner "shell" {
        inline = ["chown -R cfssl:cfssl /certs"]
    }

    provisioner "shell" {
        inline = ["rm -rf /builddir"]
    }

    provisioner "shell" {
        inline = ["echo 'Generating CA key and cert'",
        "cd /certs",
        "cfssl gencert -initca ca-csr.json | cfssljson -bare ca",
        "cd ..", 
        "tar -cvf certs.tar /certs",
        "chmod +x /entrypoint.sh"]
    }

    provisioner "file"{
        source = "/certs.tar"
        destination = "certs.tar"
        direction= "download"
    }

    post-processors {
        post-processor "docker-tag" {
            repository = var.repo
            tags = ["0.1"]
        }
        post-processor "docker-push" {
        }
    }
}