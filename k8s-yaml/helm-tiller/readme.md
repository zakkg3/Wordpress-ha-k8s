the rbac will create the role for tiller. but then you need to install helm like this:

    helm init --upgrade --service-account tiller


useful functions to add in ~/.zshrc


helmins() {
 kubectl -n kube-system create serviceaccount tiller
 kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
 helm init --service-account=tiller
}
helmdel() {
 kubectl -n kube-system delete deployment tiller-deploy
 kubectl delete clusterrolebinding tiller
 kubectl -n kube-system delete serviceaccount tiller

}
