# INSTANCES #

data "aws_ssm_parameter" "ami" {
  name = var.instance_ami
}

resource "aws_instance" "instance_nginx_servers" {
  depends_on = [
    aws_iam_role_policy.allow_s3_all,
  ]

  count = var.instances_nginx_servers_count

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets[(count.index % var.vpc_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx-profile.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2-nginx-${count.index}"
  })

  user_data = templatefile("${path.module}/startup_script.tpl",
    {
      s3_bucket_name = local.s3_bucket_name
  })

}