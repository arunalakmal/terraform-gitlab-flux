variable "gitlab_token" {
  description = "GitLab Token for the bootstrp generate it from GitLab console"
  default = "NaN"
}

variable "target_path" {
  description = "Path of the cluster configuration"
  default = "clusters/dev"
}

variable "branch" {
  description = "GitOps administrator repository branch, this will be the branch to be looked at by the Flux controllers"
  default = "master"
}

variable "gitlab_repo_path" {
  description = "GitLab repository path this should be valid to find the repository"
  default = "techcrumble"
}

variable "gitlab_project_id" {
  description = "GitLab repository ID, you can find it in the repository page at the top"
  default = "25354313"
}

variable "gitops_administrator_repo" {
  description = "Name of the repository to be treated as the GitOps Administrator"
  default = "techcrumble-gitops-administrator"
}

variable "kube_config_path" {
  description = "Path of the kubeconfig file to authenticate with the Kubernetes API"
  default = "~/.kube/config"
}

variable "flux_namespace" {
  description = "Namespace which is required for the controlloer deployments, all the Flux Controllers will be deployed in this namespace"
  default = "flux-system"
}