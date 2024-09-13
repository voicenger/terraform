
# # Generate an SSH key pair
# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # resource "local_file" "private_key" {
# #   content         = tls_private_key.example.private_key_pem
# #   filename        = "${path.module}/my-key.pem"
# #   file_permission = "0400" # Read-only permission for owner
# # }

# resource "aws_key_pair" "deployer_key" {
#   key_name   = "deployer-key"
#   public_key = tls_private_key.example.public_key_openssh
# }

# # Create IAM Role for SSM
# resource "aws_iam_role" "ssm_role" {
#   name = "ssm-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# # Attach the AmazonSSMManagedInstanceCore policy to the SSM role
# resource "aws_iam_role_policy_attachment" "ssm_attach" {
#   role       = aws_iam_role.ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
# }

# # Attach the IAM role to an instance profile
# resource "aws_iam_instance_profile" "ssm_instance_profile" {
#   name = "ssm-instance-profile"
#   role = aws_iam_role.ssm_role.name
# }

# resource "aws_instance" "web" {
#   ami           = "ami-0e872aee57663ae2d" # Ubuntu 22.04 LTS AMI ID for us-west-2
#   instance_type = "t2.micro"

#   # Associate the Elastic IP with the instance
#   associate_public_ip_address = true

#   # Use the generated key pair for SSH access
#   key_name = aws_key_pair.deployer_key.key_name

#   # Security Group that allows traffic on ports 22, 80, 443
#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   # Attach the instance profile to the EC2 instance
#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

#   tags = {
#     Name = "Terraform-EC2-Ubuntu-SSM"
#   }
# }

# resource "aws_security_group" "web_sg" {
#   name        = "web-sg"
#   description = "Allow web and SSH traffic"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_eip" "elastic_ip" {
#   instance = aws_instance.web.id
# }

# output "public_ip" {
#   value = aws_eip.elastic_ip.public_ip
# }
