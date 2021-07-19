output "kubeconfig" {
  description = "Kubeconfig of created cluster (with short-lived token)"
  value       = data.template_file.kubeconfig.rendered
}
