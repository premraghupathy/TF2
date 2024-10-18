

variable "server_port" {
	description="the http server port"
	type = number
	default=8079
}
# 1. terraform will promptto entre a value
# 2. terraform apply -var "server_port=8090"
# 3. TF_VAR_server_port=8080
# 4. if no value provided, then add default=8080

provider "aws" {
	region="us-east-1"
}

resource "aws_instance" "prem_tf_created_ec2"  {
	instance_type="t2.micro"
	ami="ami-0e86e20dae9224db8"
	subnet_id="subnet-04edb3ea22236883e" 	
	vpc_security_group_ids = [aws_security_group.prem_tf_sg.id]
	associate_public_ip_address=true
	tags={
		name="prem_tf_created_ec2"
	}
	
	user_data=<<-EOF
	#!/bin/bash
	echo "TF launched web server" > index.html
	nohup busybox httpd -f -p ${var.server_port}  &
	EOF

	user_data_replace_on_change = true

}


resource "aws_security_group" "prem_tf_sg" {
	name="tf_sg"
	vpc_id="vpc-09792a9f84354af94"
	ingress {
	from_port = var.server_port
	to_port = var.server_port
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
}

output "EC2_ip_info" {
	value=aws_instance.prem_tf_created_ec2.public_ip
	
}
