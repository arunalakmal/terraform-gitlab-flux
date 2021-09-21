# Terraform Flux Bootstrap with GitLab Repository on Kubernetes

This module is created to bootstrap FluxCD V2 on multiple Kubernetes clusters. This has been tested and used in few environments. 

## Usage 

Provide the below variables and use the modeule as below

```
module "flux" {
  source  = "ArunaLakmal/flux/gitlab"
  version = "1.0.0"

  gitlab_token = "xxxxxxx"
  target_path  = "cluster/path"
  branch       = "master"
  gitlab_repo_path  = "repository/path/in/gitlab"
  gitlab_project_id = "project_id"
  gitops_administrator_repo = "git_repository_name"
  kube_config_path  = "kubeconfig/file/path"
  flux_namespace    = "flux_namespace"
}
```

**Note:** Flux namespace is defaults to `flux-system` hence optional