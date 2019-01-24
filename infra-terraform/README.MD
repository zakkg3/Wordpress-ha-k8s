# Kubernetes Cluster - AWS K8s engine

## Instructions
commands are relative to this directory.

* configure your aws-cli (edit file ~/.aws/credentials) with a [profile] named "test-dev", if you want to use another profile name change it in state_dev and in dev.tfvars files.

    Note git will ignore all "*NOCOMMIT*", to avoid stage/commit/push sensitive data.

* Create a s3_bucket named "k8s-tf-state-dev" its where we will store the remote state for this project running this:

    cd bucket/
    terraform init
    terrform apply -var-file ../dev.tfvars


## Plan / Apply

This Will create the Kube config file inside resources/[workspace]/kubeconfig.yml
Basicaly will create a new vpc with cidr 10.10.0.0/24 (change the default value in varaibles.tf or define it in dev.tfvars ) with subnets default gateway, the route table with the default route to the ENI, roles, and the EKS cluster with 3 nodes.
But first, Configure your ip address/32 in dev.tfvars "admin_ip"

    terraform init -backend-config state_dev
    terraform apply -var-file dev.tfvars

Be paptient, it takes time...

    aws_eks_cluster.k8s-demo-cluster: Still creating... (9m20s elapsed)


# Conect to the cluster

## aws-iam-authenticator required.


#### Install

        curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator

        chmod +x ./aws-iam-authenticator

#### Add to Path

        cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
        echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile

https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html

        echo $(terraform output kubeconfig) > ~/.kube/eksconfig
        export KUBECONFIG=~/.kube/eksconfig
        export AWS_PROFILE=test-dev

➜  Documents kubectl get all
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   3h


# Kubectl cli


## Config kubectl

A kubectl config was created by terraform. Note this config is meant to use common profiles names in ~./aws_config
You can get the kubeconfig in the output by runing

    terraform output kubeconfig

set the envvar for kubectl to use our config:

    export KUBECONFIG=resources/{terraform.workspace}/kubecfg.yaml
    kubectl get all

output:

        NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
        kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   1h

### Persist KUBECONFIG


replace the path with your KUBECONFIG file.
replace the ~/.bash_profile for bash users.

    echo 'export KUBECONFIG=~/.kube/eksconfig' >> ~/.zshrc


## Dashboard

You need kubectl already working

### Get the token

you can find it in 1 password eks-qa-wc-eks-admin-token
or run

        kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep wc-eks-admin | awk '{print $1}')

copy the token in the output

### Access dashboard
        kubectl proxy

open in your browser
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

use the token to log-in


### Dahboard documentation

Follow this
https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
