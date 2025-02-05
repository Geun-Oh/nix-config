{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
#    k3d
#    kubectl
#    kubernetes-helm
   # minikube
    #kustomize_4
  ];
}
