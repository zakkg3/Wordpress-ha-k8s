resource "aws_eks_cluster" "k8s-cluster" {
  name            = "${var.env}-k8-cluster"
  role_arn        = "${aws_iam_role.eks-role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.k8s-master.id}"]
    #minimum 2, for testing using. use aws_subnet.k8s.*.id for prod.
    subnet_ids         = ["${aws_subnet.k8s.*.id}"]
  }

  # depends_on = [
  #   "aws_iam_role_policy_attachment.eks-example-AmazonEKSClusterPolicy",
  #   "aws_iam_role_policy_attachment.eks-example-AmazonEKSServicePolicy",
  # ]
}
