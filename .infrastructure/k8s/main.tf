terraform {
  required_version = "1.3.3"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.8.0"
    }
  }
}

resource "helm_release" "nginx_ingress" {
  ## Arbitrary name for our ingress
  name       = "nginx-ingress-controller"
  ## Defines where Helm should look for the Chart we want to install
  repository = "https://kubernetes.github.io/ingress-nginx"
  ## Define the name of the Chart we want to install
  chart      = "ingress-nginx"

  ## Below we define some "Options" for the installation of our Chart

  ## Links the Load Balancer the Ingress will create to the IP we defined on
  ## .infrastructure/scaleway/k8s.tf (scaleway_lb_ip)
  set {
    name = "controller.service.loadBalancerIP"
    value = var.nginx_ip
  }

  ## Custom Configuration that enable/disables usage of the PROXY protocol (https://docs.nginx.com/nginx/admin-guide/load-balancer/using-proxy-protocol/)
  ## that to summarize, enables us to receive the Client connection information (like the real IP of the client)
  ## through our Load Balancer. To view all Custom Configurations you can access: (https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/)
  set {
    name = "controller.config.use-proxy-protocol"
    value = "true"
  }

  ## Custom Scaleway configuration - Enables us to utilize the PROXY protocol with the latest version (v2)
  ## You can check all Scaleway custom configurations for this Controller here: (https://github.com/scaleway/scaleway-cloud-controller-manager/blob/master/scaleway/loadbalancers.go)
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
    value = "true"
  }

  ## Custom Scaleway configuration - Defines in which Scaleway zone the Ingress Controller will create the Load Balancer
  ## In this case, we want to utilize the same zone that we created our Load Balancer IP (defined in .infrastructure/scaleway/k8s.tf (scaleway_lb_ip))
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
    value = var.nginx_zone
  }

  ## Setting this value to Local prevents a request received in one node to be forwarded by kube-proxy to another Node
  ## Preserving the client IP address through-out the entire request life-cycle
  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

}


#resource "helm_release" "vault" {
#  ## Arbitrary name for the vault
#  name       = "vault"
#  ## Defines where Helm should look for the Chart we want to install
#  repository = "https://helm.releases.hashicorp.com"
#  ## Define the name of the Chart we want to install
#  chart      = "vault"
#
#  create_namespace = true
#
#  namespace = "vault"
#
#  set {
#    name = "installCRDs"
#    value = "true"
#  }
#
#  set {
#    name  = "ui.enabled"
#    value = "true"
#  }
#}