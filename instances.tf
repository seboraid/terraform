# INSTANCES #

data "aws_ssm_parameter" "ami" {
  name = var.instance_ami
}

resource "aws_instance" "instance_nginx_servers" {
  depends_on = [
    module.s3mio
  ]

  count = var.instances_nginx_servers_count

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[(count.index % var.vpc_subnet_count)]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  iam_instance_profile   = module.s3mio.aws_iam_instance_profile.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}ec2-nginx-${count.index + 1}"
  })

  user_data = templatefile("${path.module}/startup_script.tpl",
    {
      s3_bucket_name = module.s3mio.bucket.bucket
  })

}