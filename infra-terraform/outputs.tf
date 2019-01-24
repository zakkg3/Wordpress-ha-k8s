locals {
  kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.k8s-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.k8s-cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      env:
      - name: "AWS_PROFILE"
        value: "${var.profile}"
      args:
        - "token"
        - "-i"
        - "${var.env}-k8-cluster"
KUBECONFIG
}
# - "-r"
# - "<role-arn>"
# env:
# - name: AWS_PROFILE
#   value: "<aws-profile>"


output "kubeconfig" {
  value = "${local.kubeconfig}"
}


locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}
output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}



resource "local_file" "create_config_map" {
    content = "${local.config_map_aws_auth}"
    filename  = "./resources/config_map_aws_auth.yaml"
}

resource "local_file" "create_kubecfg" {
    content = "${local.kubeconfig}"
    filename  = "./resources/kubecfg.yaml"
}
