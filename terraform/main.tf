provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/pete/.aws/config"
}

resource "aws_instance" "minecraft" {
    ami = "ami-0970ab4b97fe3a913"
    key_name = "pete-aws-personal"
    instance_type = "t2.micro"

    security_groups = [
        "ssh"
    ]

    tags {
        Name = "minecraft"
    }

    provisioner "remote_exec" {
        inline = [
            "sudo useradd -m -d /home/minecraft/ -s /bin/bash minecraft",
            "sudo mkdir /usr/bin/minecraft",
        ]
    }

    provisioner "file" {
        source      = "mc_env_vars.txt"
        destination = "/home/minecraft/mc_env_vars.txt"
    }
    
    provisoner "file" {
        source      = "files/"
        destination = "/usr/bin/minecraft/"
    }

    provisoner "remote_exec" {
        inline = [
            "chown -R minecraft: /usr/bin/minecraft/",
            "chmod +x /usr/bin/minecraft/*"
        ]
    }
}
