locals {
  name_eni = "us-east-1"
}

resource "helm_release" "eniconfig" {
  name       = "eniconfig"
  chart      = "../../helm/eniconfig"
  namespace  = "default"
  timeout    = 390

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name = "az_a.name"
    value = "${local.name_eni}a"
  }

  set {
    name = "az_a.sgs[0]"
    value = data.terraform_remote_state.eks.outputs.nodes_sg_id
  }

  set {
    name = "az_a.subnet"
    value = data.terraform_remote_state.vpc.outputs.pods_subnets[0]
  }

  set {
    name = "az_b.name"
    value = "${local.name_eni}b"
  }

  set {
    name = "az_b.sgs[0]"
    value = data.terraform_remote_state.eks.outputs.nodes_sg_id
  }

  set {
    name = "az_b.subnet"
    value = data.terraform_remote_state.vpc.outputs.pods_subnets[1]
  }

  set {
    name = "az_c.name"
    value = "${local.name_eni}c"
  }

  set {
    name = "az_c.sgs[0]"
    value = data.terraform_remote_state.eks.outputs.nodes_sg_id
  }

  set {
    name = "az_c.subnet"
    value = data.terraform_remote_state.vpc.outputs.pods_subnets[2]
  }
}
