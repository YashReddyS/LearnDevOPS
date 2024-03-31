provider "google" {
  project     = "learndevops-418907"
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster-final"
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1

}


resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
  }
}

