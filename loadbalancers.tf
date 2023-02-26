## aws_elb_service_account

data "aws_elb_service_account" "root" {}

## aws_lb
resource "aws_lb" "nginx" {
  name               = "globo-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = module.s3mio.bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}alb-logs"
  })
}

## aws_lb_target_group

resource "aws_lb_target_group" "nginx" {
  name     = "${local.name_prefix}alb-tg-nginx"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    healthy_threshold   = 2
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}alb-tg-nginx"
  })
}

## aws_lb_listener
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}alb-listener-nginx"
  })
}


## aws_lb_target_group_attachment

resource "aws_lb_target_group_attachment" "nginx-servers" {
  count            = var.instances_nginx_servers_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.instance_nginx_servers[count.index].id
  port             = 80
}