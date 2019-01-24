# k8s-WordPress-ha

[![pipeline status](https://gitlab.com/zakkg3/k8s-wordpress-ha/badges/master/pipeline.svg)](https://gitlab.com/zakkg3/k8s-wordpress-ha/commits/master)

A minimalistic production‑ready environment running Wordpress in Kubernetes with AWS EKS, Terraform, HELM, GilabCI with a Python CLI.

## Quickstart

### Requirements

Please install the latest versions of:

- Python
- Terraform
- HELM
- aws-iam-authenticator

    Linux: https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator

    MacOS: https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator

Also its needed:

- AWS account with admin profile named "test-dev". Usually to edit the file:

    vi ~/.aws/credentials

### Get started

There is a cli to automate some tasks, for help run:

    ./wpk8s-cli --help

- Print help.

### 1. Create the infrastructure: (-a | -apply)

    ./wpk8s-cli -apply

This will:
- cd into infra-terraform/bucket, init and apply: creating an s3 bucket for the terraform backend.
- cd into infra-terraform and init, apply the infrastructure. creating the config file for kubectl with the token (don't share this file is secret and its .gitigored) and the Role binding for allow nodes to join the cluster.


### 2. Basic Configuration, kubectl and RBAC: (-k | --kubeconfig)

    ./wpk8s-cli -k

- Export KUBECONFIG with a YAML config file for kubectl created in the previous step. (/infra-terraform/resources/kubecfg.yaml)
- Apply recipes for Create service account and admin - role binding it.
- Apply config map aws-auth in kube-system namespace to map the role created for the nodes to groups system bootstrappers and nodes. This allows EC2 instances with this role to join the cluster.


### 3. Initilize Helm, instal tiller: (-hi | --helminit)

    ./wpk8s-cli -hi

- helm init
- helm update

### 4.  Install chart ( -i  | --install )

    ./wpk8s-cli -i

- helm install chart in custom-chart/ folder.

### 5. Upgrade (-u | --upgrade)

On every push, GilabCi will use a shared runner to build and push the image from Wordpress/Dockerfile. It also will upgrade the helm project in the cluster.

    ./wpk8s-cli -u

### 5. Congigure CD/CI

CD/CI is on GitlabCI : https://gitlab.com/zakkg3/k8s-wordpress-ha
For the deploy, we need to have the kubeconfig in a variable "kube_config" in GitlabCI. The deploy stage uses this to execute kubectl and helm commands.


### Toolsets:

Container Management: Kubernetes (Amazon Elastic Container Service for Kubernetes)
Deployable Artifact: Docker Image created form provided Dockerfile.
Deploy Method: Kubernetes yaml files / HELM
CI/CD: GitlabC
Scripting Language: Bash, Python.


# Final notes.  

* Inside infra-terraform there is another README with notes about the infrastructure creation process.

* Please find in ANALYSIS.md some things it will be nice to have in a production environment.

Feel free to open issues and send PR's.
