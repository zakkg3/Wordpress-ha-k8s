data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}



data "aws_region" "current" {}

locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.k8s-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8s-cluster.certificate_authority.0.data}' '${var.env}-k8-cluster'
USERDATA
}

resource "aws_launch_configuration" "k8s-nodes" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "${var.node_type}"
  name_prefix                 = "eks-${var.env}"
  security_groups             = ["${aws_security_group.node.id}"]
  user_data_base64            = "${base64encode(local.node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "k8s-nodes" {
  desired_capacity     = "${var.desired_nodes}"
  launch_configuration = "${aws_launch_configuration.k8s-nodes.id}"
  max_size             = "${var.desired_nodes}"
  min_size             = 0
  name                 = "EKS-nodes-${var.env}"
  vpc_zone_identifier  = ["${aws_subnet.k8s.*.id}"]

  tag {
    key                 = "Name"
    value               = "EKS-nodes-${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.env}-k8-cluster"
    value               = "owned"
    propagate_at_launch = true
  }
}
