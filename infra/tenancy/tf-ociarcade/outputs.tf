output "arcade_compute_ip_addr" {
  value = oci_core_instance.export_arcade-web.public_ip
}

output "arcade_adw_apex_url" {
  value = lookup(oci_database_autonomous_database.export_arcade.connection_urls[0],"apex_url")
}

output "objectstorage_namespace" {
  value = var.bucket_ns
}

output "region" {
  value = var.region
}

