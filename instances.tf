# INSTANCES #

data "aws_ssm_parameter" "ami" {
    name = var.instance_ami
}

resource "aws_instance" "nginx1" {
  depends_on = [
    aws_iam_role_policy.allow_s3_all,
  ]

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  iam_instance_profile  = aws_iam_instance_profile.nginx-profile.name

  tags = local.common_tags

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${local.s3_bucket_name}/website/index.html /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${local.s3_bucket_name}/website/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
EOF

}

resource "aws_instance" "nginx2" {
  depends_on = [
    aws_iam_role_policy.allow_s3_all,
  ]

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  iam_instance_profile  = aws_iam_instance_profile.nginx-profile.name

  tags = local.common_tags

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${local.s3_bucket_name}/website/index.html /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${local.s3_bucket_name}/website/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
EOF

}