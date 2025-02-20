
provider "aws" {
  region = "us-east-1"
}

provider "google" {
  credentials = file("<path-to-your-service-account-key>.json")
  project     = "<gcp-project-id>"
  region      = "us-central1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "multi-cloud-cluster-aws"
  cluster_version = "1.25"
  subnets         = ["<subnet-ids>"]
  vpc_id          = "<vpc-id>"
  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
    }
  }
}

module "gke" {
  source       = "terraform-google-modules/kubernetes-engine/google"
  project_id   = "<gcp-project-id>"
  name         = "multi-cloud-cluster-gcp"
  region       = "us-central1"
  network      = "default"
  subnetwork   = "default"
  node_pools = [
    {
      name               = "default-pool"
      machine_type       = "e2-medium"
      node_count         = 2
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      service_account    = "<service-account-email>"
    }
  ]
}
