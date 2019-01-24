resource "aws_security_group" "k8s-master" {
  name        = "EKS-master-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.k8s.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "EKS-master-sg"
  }
}

resource "aws_security_group_rule" "ingress-wcoffice" {
  cidr_blocks       = ["${var.admin_ip}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.k8s-master.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.k8s-master.id}"
  source_security_group_id = "${aws_security_group.node.id}"
  to_port                  = 443
  type                     = "ingress"
}
