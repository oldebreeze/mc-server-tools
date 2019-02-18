provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/pete/.aws/config"
}

resource "aws_instance" "minecraft" {
    ami           = "ami-0970ab4b97fe3a913"
    key_name      = "pete-aws-personal"
    instance_type = "t2.micro"

    security_groups = [
        "ssh"
    ]

    tags {
        Name = "minecraft"
    }

    provisioner "remote-exec" "add_user" {
        inline = [
            "sudo useradd -m -d /home/minecraft/ -s /bin/bash minecraft",
            "sudo mkdir /usr/bin/minecraft",
        ]
        connection = {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("/home/pete/.ssh/pete-aws-personal.pem")}"
        }
    }

    provisioner "file" "add_env_vars" {
        source      = "mc_env_vars.txt"
        destination = "/tmp/mc_env_vars.txt"
        connection = {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("/home/pete/.ssh/pete-aws-personal.pem")}"
        }
    }
    
    provisioner "file" "add_bin_files" {
        source      = "files/"
        destination = "/tmp/"
        connection = {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("/home/pete/.ssh/pete-aws-personal.pem")}"
        }
    }

    provisioner "remote-exec" "set_perms_run_install" {
        inline = [
            "sudo mv /tmp/mc_env_vars.txt /home/minecraft/mc_env_vars.txt",
            "chown -R minecraft: /usr/bin/minecraft/",
            "chmod +x /usr/bin/minecraft/*"
#            "/usr/bin/minecraft/minecraft_install.sh"
        ]
        connection = {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("/home/pete/.ssh/pete-aws-personal.pem")}"
        }
    }
}
