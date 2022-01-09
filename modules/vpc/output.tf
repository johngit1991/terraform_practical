output "subnet_id2"{
    value=aws_subnet.dev_pubsubnet.id
}

output "sg_id"{
    value=aws_security_group.dev-sg.id
}