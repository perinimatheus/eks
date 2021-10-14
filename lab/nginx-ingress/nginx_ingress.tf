resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  chart      = "../../helm/ingress-nginx"
  namespace  = "kube-system"
  timeout    = 390

  values = [
    "${file("values.yaml")}"
  ]
}