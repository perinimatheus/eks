resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  chart      = "../../helm/ingress-nginx"
  namespace  = "kube-system"
  timeout    = 390

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = "arn:aws:acm:us-east-1:936619164022:certificate/fc51847c-34f5-4e3c-81e9-f18822b7b218"
  }
}