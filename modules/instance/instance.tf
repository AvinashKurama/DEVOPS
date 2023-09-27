resource "aws_instance" "jenkins" {
  ami                          = var.v_ami   # Replace with your desired AMI ID
  instance_type                = local.instance_type[terraform.workspace]                # Replace with your desired instance type
  key_name                     = var.v_key_name             # Replace with your SSH key pair name
  subnet_id                    = var.v_sn1[0] # Replace with your subnet ID
  availability_zone            = var.v_az[0]               # Replace with your desired availability zone
  associate_public_ip_address  = true                       # Assign a public IP address
  vpc_security_group_ids       = [var.v_sg_web]
  user_data                    = <<-EOF
    #!/bin/bash
      sudo apt update -y
      sudo apt install -y openjdk-8-jdk

      # Add Jenkins repository and key
      wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
      sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
      sudo apt update -y

      # Install Jenkins and its dependencies
      sudo apt install -y jenkins

      # Start Jenkins service
      sudo systemctl start jenkins
      sudo systemctl enable jenkins
  EOF 
  

  tags = {
    Name = "jenkins-instance-${terraform.workspace}"
  }
}




locals {
  instance_type ={
    dev = "t2.micro"
    stage = "t2.medium"
    prod  = "t2.micro"
  }

}






#   iam_instance_profile         = "my-instance-profile"      # Replace with your IAM instance profile name or ARN
#   monitoring                   = true                       # Enable detailed monitoring
#   disable_api_termination      = false                      # Allow API termination
#   instance_initiated_shutdown_behavior = "terminate"         # Set shutdown behavior ("terminate" or "stop")
#   ebs_optimized                = true                       # Enable EBS optimization

#   instance_initiated_shutdown_behavior = "terminate"         # Set shutdown behavior ("terminate" or "stop")
#   root_block_device {
#     volume_type           = "gp2"                            # EBS volume type (e.g., gp2, io1)
#     volume_size           = 30                               # EBS volume size in GB
#     delete_on_termination = true                             # Delete the volume on instance termination
#   }
#   ebs_block_device {
#     device_name           = "/dev/sdf"                       # Device name
#     volume_type           = "gp2"                            # EBS volume type (e.g., gp2, io1)
#     volume_size           = 50                               # EBS volume size in GB
#     delete_on_termination = true                             # Delete the volume on instance termination
#     encrypted             = true                             # Encrypt the EBS volume