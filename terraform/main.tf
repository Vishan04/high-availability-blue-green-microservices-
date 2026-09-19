terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# =========================
# NAMESPACES
# =========================

resource "kubernetes_namespace" "blue" {
  metadata {
    name = "blue"
  }
}

resource "kubernetes_namespace" "green" {
  metadata {
    name = "green"
  }
}

resource "kubernetes_namespace" "routing" {
  metadata {
    name = "routing"
  }
}

# =========================
# BLUE FRONTEND
# =========================

resource "kubernetes_deployment" "blue_frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.blue.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app     = "frontend"
        version = "blue"
      }
    }

    template {
      metadata {
        labels = {
          app     = "frontend"
          version = "blue"
        }
      }

      spec {
        container {
          name              = "frontend"
          image             = "blue-green-frontend:v1"
          image_pull_policy = "Never"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# =========================
# GREEN FRONTEND
# =========================

resource "kubernetes_deployment" "green_frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.green.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app     = "frontend"
        version = "green"
      }
    }

    template {
      metadata {
        labels = {
          app     = "frontend"
          version = "green"
        }
      }

      spec {
        container {
          name              = "frontend"
          image             = "blue-green-frontend:v2"
          image_pull_policy = "Never"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# =========================
# BLUE PRODUCT SERVICE
# =========================

resource "kubernetes_deployment" "blue_product_service" {
  metadata {
    name      = "product-service"
    namespace = kubernetes_namespace.blue.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app     = "product-service"
        version = "blue"
      }
    }

    template {
      metadata {
        labels = {
          app     = "product-service"
          version = "blue"
        }
      }

      spec {
        container {
          name              = "product-service"
          image             = "blue-green-product-service:v1"
          image_pull_policy = "Never"

          port {
            container_port = 5001
          }
        }
      }
    }
  }
}

# =========================
# GREEN PRODUCT SERVICE
# =========================

resource "kubernetes_deployment" "green_product_service" {
  metadata {
    name      = "product-service"
    namespace = kubernetes_namespace.green.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app     = "product-service"
        version = "green"
      }
    }

    template {
      metadata {
        labels = {
          app     = "product-service"
          version = "green"
        }
      }

      spec {
        container {
          name              = "product-service"
          image             = "blue-green-product-service:v2"
          image_pull_policy = "Never"

          port {
            container_port = 5001
          }
        }
      }
    }
  }
}

# =========================
# BLUE FRONTEND SERVICE
# =========================

resource "kubernetes_service" "blue_frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.blue.metadata[0].name
  }

  spec {
    selector = {
      app     = "frontend"
      version = "blue"
    }

    port {
      port        = 5000
      target_port = 5000
    }
  }
}