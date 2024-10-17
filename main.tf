provider "aws" {
	region="us-east-1"
}

resource "aws_instance" "prem_tf_created"  {
	instance_type="t2.micro"
	ami="ami-0e86e20dae9224db8"
	subnet_id="subnet-04edb3ea22236883e" 	
	vpc_security_group_ids = [aws_security_group.prem_tf_sg.id]

	tags={
		name="prem_tf_created_ec2"
	}
	
	user_data=<<-EOF
	#!/bin/bash
	echo "TF launched web server" > index.html
	nohup busybox httpd -f -p 8099 &
	EOF

	user_data_replace_on_change = true

}


resource "aws_security_group" "prem_tf_sg" {
	name="tf_sg"
	vpc_id="vpc-09792a9f84354af94"
	ingress {
	from_port = 8099
	to_port = 8099
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
}
