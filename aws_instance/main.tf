// inet-test1
resource "aws_instance" "inet-test1" {
    ami = var.ami
    instance_type = var.instance_type_x

    tags = {
        Name = "inet-test1"
    }

    user_data = file("./init.sh")

    key_name = aws_key_pair.devops.id
    vpc_security_group_ids = [aws_security_group.index-private-full-acces.id]

    provisioner "file" {
        source = "./docker-compose.yml"
        destination = "/home/ubuntu/docker-compose.yml"
        connection {
            type = "ssh"
            host = self.private_ip
            user = "ubuntu"
            private_key = file("./id_rsa")
        }
    }

    root_block_device {
        volume_size           = "40"
        volume_type           = "gp2"
    }

    private_ip = var.private_ip_inet_test1
    subnet_id  = var.private_ip_subnet
    
    #lifecycle {
    #    ignore_changes = all
    #}
}
// inet-test2
resource "aws_instance" "inet-test2" {
    ami = var.ami
    instance_type = var.instance_type_en_x

    tags = {
        Name = "inet-test2"
    }

    user_data = file("./init.sh")

    key_name = aws_key_pair.devops.id
    vpc_security_group_ids = [aws_security_group.index-private-full-acces.id]

    connection {
        type = "ssh"
        host = self.private_ip
        user = "ubuntu"
        private_key = file("./id_rsa")
    }

    root_block_device {
        volume_size           = "40"
        volume_type           = "gp3"
    }

    private_ip = var.private_ip_inet_test2
    subnet_id  = var.private_ip_subnet
}
resource "aws_key_pair" "devops" {
    public_key = file("./id_rsa.pub")
}
