# **<u>---------------- Em Construção ---------------</u>**

# **<u>Documentação</u>**

## **<u>VPC</u>**

<p>Criação de uma vpc, 3 public subnets, 3 private subnets e, caso necessite, coloque o valor da variavel enable_secondary_cidr como true para a criação do cidr secundario e das 3 pods subnets (cluster irá usar essas subnets para alocar os pods)</p>

 > terraform -chdir=lab/vpc/ apply

## **<u>EKS</u>**

<p>Criação do cluster eks</p>

- Para utilizar o cidr secundario, altere a variavel subnet_ids para o valor abaixo:

  - > subnet_ids = data.terraform_remote_state.vpc.outputs.pods_subnets

 > terraform -chdir=lab/eks/ apply

## **<u>ENICONFIG</u>**

<p>Configuração do eni para a utilização do cidr secundario e alocação de ips</p>

**`OBS: Caso não use cidr secundario, skip esse step e vá para a configuração dos node groups!!!!`**

1. ### **CONFIGURE ENI**

  - ### Para que os pods utilizem o CIDR secundario da vpc
  
    - > kubectl set env daemonset aws-node -n kube-system AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=true

  - ### Para aplicar automaticamente o ENIConfig correspondente para a zona de disponibilidade do nó

    - > kubectl set env daemonset aws-node -n kube-system ENI_CONFIG_LABEL_DEF=failure-domain.beta.kubernetes.io/zone

  - ### Para pods em subnet privada se comunicar com através de Direct Connect, VPC Peering or Transit VPC

    - > kubectl set env daemonset aws-node -n kube-system AWS_VPC_K8S_CNI_EXTERNALSNAT=true

  - ### Para sempre ter 5 ips disponilizados mas não utilizados

    - > kubectl set env daemonset aws-node -n kube-system WARM_IP_TARGET=5

  - ### Para iniciar com 10 ips disponibilizados

    -  > kubectl set env daemonset aws-node -n kube-system MINIMUM_IP_TARGET=10

2. ### **REALIZE O APPLY**

- > terraform -chdir=lab/eniconfig/ apply

## **<u>NODE-GROUP</u>**

<p>Criação do node group</p>

- Caso queira limitar o numero de pods por instancia, siga os passos abaixo:

  - Verifique a quantidade de pods recomendados para o tipo de instacia que você deseja, execute o script abaixo substituindo `<m5.large>` (incluindo <>) pelo tipo de   instância que você planeja implantar e `<1.9.x- eksbuild.y>` ou posterior pela versão complementar do CNI da Amazon VPC

    - Para verificar a versão do CNI execute o seguinte comando:

      - > kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2

    - > ./max-pods-calculator.sh --instance-type `<m5.large>` --cni-version `<1.9.x-eksbuild.y>` --cni-custom-networking-enabled

  - Ao obter a quantidade de pods recomendada, altere o valor da variavel `kubelet_extra_args` para `--max-pods=<QTD PODS>`

 > terraform -chdir=lab/ng_shared/ apply

## **<u>CLUSTER AUTOSCALER</u>**

<p>Deploy do cluster autoscaler</p>

 > terraform -chdir=lab/cluster-autoscaler/ apply

## **<u>NGINX INGRESS CONTROLLER</u>**

<p>Deploy do nginx ingress controller</p>

 > terraform -chdir=lab/nginx-ingress/ apply

## **<u>EXTERNAL DNS</u>**

<p>Deploy do external dns</p>

- Altere o valor da variavel hostedzone para o id da `hostedzone` no route53 e o valor da variavel `domainFilters` para o dominio desejado.

 > terraform -chdir=lab/external-dns/ apply


