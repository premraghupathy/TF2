provider "aws" {
	region="us-east-1"
}

resource "aws_instance" "prem_tf_created"  {
	instance_type="t2.micro"
	ami="ami-0e86e20dae9224db8"
	subnet_id="subnet-04edb3ea22236883e" 	
}


