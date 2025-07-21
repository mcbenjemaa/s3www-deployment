output "id" {
  value       = helm_release.release.id
  description = "The ID of the release"
}

output "metadata" {
  value       = helm_release.release.metadata
  description = "The metadata of the release"
}
