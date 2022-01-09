data "aws_ami" "dev-ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "dev-instance"{
    ami=data.aws_ami.dev-ami.id
    instance_type=var.instance_type
    subnet_id=var.subnet_id1 
    availability_zone = var.availability_zone              
    vpc_security_group_ids=var.sg         
    associate_public_ip_address=true
    key_name=var.key_name
    /* user_data= <<EOF
                    #!/bin/bash
                    sudo yum update -y
                    sudo yum install git -y
                    sudo git version
                EOF */
    user_data = file(var.userdata_entryscript)  
   
    provisioner "file"{
                        source = file(var.remote_exec_script)
                        destination = "/home/ec2-user/remote_script.sh"
    }
/* to excute remote_script.sh file in remote_exec we need to copy file using  file provisioner to remote. */

    provisioner "remote-exec" {
                       /* inline =["export ENV = dev", "mkdir test"] */
                       script = file(var.remote_exec_script)         
    }
    
    provisioner "local-exec"{
                        command = "echo ${self.public_ip}"
    }

    connection {
                        type = "ssh"
                        host ="self.public_ip"
                        user ="ec2-user"
                        private_key= file(var.private_key_path)
    }
        
    tags = {
        name = "dev-instance"
    }
}
