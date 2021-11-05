resource "helm_release" "app_lab" {
  name       = "app-lab"
  chart      = "../../helm/app-lab"
  namespace  = "default"
  timeout    = 390

  values = [
    "${file("values.yaml")}"
  ]

}
