module "nuskusa_app_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "nuskusa-app-alb"

  load_balancer_type = "application"

  vpc_id          = local.vpc_id
  subnets         = local.subnets
  security_groups = local.security_groups

  target_groups = [
    {
      name_prefix      = "app-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  #  https_listeners = [
  #    {
  #      port               = 443
  #      protocol           = "HTTPS"
  #      target_group_index = 0
  #        certificate_
  #    }
  #  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {}
}
