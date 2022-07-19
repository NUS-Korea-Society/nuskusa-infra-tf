resource "aws_codedeploy_deployment_group" "infra" {
  app_name              = aws_codedeploy_app.nuskusa.name
  deployment_group_name = "infra"
  service_role_arn      = local.codedeploy_role_arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "nuskusa_infra_asg"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  autoscaling_groups = [data.terraform_remote_state.asg.outputs.infra-asg-name]

    deployment_config_name = "CodeDeployDefault.AllAtOnce"

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = data.terraform_remote_state.asg.outputs.infra-alb-target-group-names[0]
    }
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "DeploymentFailureTrigger"
    trigger_target_arn = module.sns_topic.sns_topic_arn
  }

}
