## This configuration was generated by terraform-provider-oci

resource tls_private_key public_private_key_pair {
  algorithm   = "RSA"
}

resource oci_core_instance export_arcade-web {
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = data.oci_identity_availability_domain.export_GrMp-AP-SYDNEY-1-AD-1.name
  compartment_id      = var.compartment_ocid
  create_vnic_details {
    assign_public_ip = "true"
    display_name = "arcade-web"
    freeform_tags = {
    }
    hostname_label = "arcade-web"
    nsg_ids = [
    ]
    private_ip             = "10.0.0.3"
    skip_source_dest_check = "false"
    subnet_id              = oci_core_subnet.export_Public-Subnet.id
    #vlan_id = <<Optional value not found in discovery>>
  }
  #dedicated_vm_host_id = <<Optional value not found in discovery>>
  display_name = "arcade-web"
  extended_metadata = {
  }
  fault_domain = "FAULT-DOMAIN-1"
  freeform_tags = {
  }
  #ipxe_script = <<Optional value not found in discovery>>
  #is_pv_encryption_in_transit_enabled = <<Optional value not found in discovery>>
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = "true"
    # is_pv_encryption_in_transit_enabled = "false"
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
    "ssh_authorized_keys" = "${var.custom_ssh_key}\n${tls_private_key.public_private_key_pair.public_key_openssh}"
  }
  #preserve_boot_volume = <<Optional value not found in discovery>>
  shape = var.compute_shape
  source_details {
    #boot_volume_size_in_gbs = <<Optional value not found in discovery>>
    #kms_key_id = <<Optional value not found in discovery>>
    source_id   = var.arcade-web_source_image_id
    source_type = "image"
  }
  state = "RUNNING"
}
resource null_resource export_arcade-web_file {
  depends_on = [oci_core_instance.export_arcade-web]
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner file {
    source      = "scripts"
    destination = "/tmp"
  }
}
resource null_resource export_arcade-web_file_privatekey {
  depends_on = [oci_core_instance.export_arcade-web]
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner file {
    content     = tls_private_key.public_private_key_pair.private_key_pem
    destination = "/tmp/terraform_api_key.pem"
  }
}
resource null_resource export_arcade-web_file_publickey {
  depends_on = [oci_core_instance.export_arcade-web]
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner file {
    content     = tls_private_key.public_private_key_pair.public_key_pem
    destination = "/tmp/terraform_api_public_key.pem"
  }
}
resource null_resource export_arcade-web_file_ociconfig {
  depends_on = [oci_core_instance.export_arcade-web]
  count = var.enable_api_key ? 1 : 0
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner file {
    content     = "[DEFAULT]\nuser=${var.user_id}\nfingerprint=${oci_identity_api_key.current_user_api_key[count.index].fingerprint}\ntenancy=${var.tenancy_ocid}\nregion=${var.region}\nkey_file=/home/oracle/.oci/terraform_api_key.pem\n"
    destination = "/tmp/config"
  }
}
resource null_resource export_arcade-web_file_wallet {
  depends_on = [local_file.export_arcade_wallet_file]
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner file {
    source     = "${path.module}/arcade-wallet.zip"
    destination = "/tmp/arcade-wallet.zip"
  }
}
resource null_resource export_arcade-web_remote-exec {
  depends_on = [null_resource.export_arcade-web_file]
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner remote-exec {
    inline = [
      "chmod +x /tmp/scripts/bootstrap-server.sh",
      "sudo /tmp/scripts/bootstrap-server.sh",
	  "curl -LSs https://raw.githubusercontent.com/fnproject/cli/master/install | sh"
    ]
  }
}
resource null_resource export_arcade-web_remote-exec_oracle {
  depends_on = [null_resource.export_arcade-web_remote-exec,oci_database_autonomous_database.export_arcade]
  
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.export_arcade-web.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner remote-exec {
    inline = [
      "chmod +x /tmp/scripts/bootstrap-user.sh",
      "sudo su - oracle bash -c '/tmp/scripts/bootstrap-user.sh ${var.custom_adb_admin_password} ${oci_database_autonomous_database.export_arcade.connection_urls[0]["apex_url"]} ${oci_core_instance.export_arcade-web.public_ip} ${var.enable_api_key} ${var.bucket_ns}'"
    ]
  }
}
resource oci_core_internet_gateway export_Internet-Gateway-vcn-20200918-0835 {
  compartment_id = var.compartment_ocid
  display_name = "OCI Arcade Internet Gateway"
  enabled      = "true"
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.export_vcn-20200918-0835.id
}
resource oci_core_subnet export_Public-Subnet {
  #availability_domain = <<Optional value not found in discovery>>
  cidr_block     = "10.0.0.0/24"
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_vcn.export_vcn-20200918-0835.default_dhcp_options_id
  display_name    = "Public Subnet"
  dns_label       = "subnet"
  freeform_tags = {
  }
  #ipv6cidr_block = <<Optional value not found in discovery>>
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_vcn.export_vcn-20200918-0835.default_route_table_id
  security_list_ids = [
    oci_core_vcn.export_vcn-20200918-0835.default_security_list_id,
  ]
  vcn_id = oci_core_vcn.export_vcn-20200918-0835.id
}
# resource oci_core_private_ip export_arcade-web_1 {
#   display_name = "arcade-web"
#   freeform_tags = {
#   }
#   hostname_label = "arcade-web"
#   ip_address     = "10.0.0.3"
#   #vlan_id = <<Optional value not found in discovery>>
#   vnic_id = "ocid1.vnic.oc1.ap-sydney-1.abzxsljreorzihyq2yonxjnsk46luyvj3sh62yndgwxm7ehh5d2sbd7dr7fq"
# }
resource oci_core_vcn export_vcn-20200918-0835 {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name = "OCI Arcade VCN"
  dns_label    = "vcn"
  freeform_tags = {
  }
  #ipv6cidr_block = <<Optional value not found in discovery>>
  #is_ipv6enabled = <<Optional value not found in discovery>>
}
resource oci_core_default_dhcp_options export_Default-DHCP-Options-for-vcn-20200918-0835 {
  display_name = "Default DHCP Options for OCI Arcade VCN"
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.export_vcn-20200918-0835.default_dhcp_options_id
  options {
    custom_dns_servers = [
    ]
    #search_domain_names = <<Optional value not found in discovery>>
    server_type = "VcnLocalPlusInternet"
    type        = "DomainNameServer"
  }
  options {
    #custom_dns_servers = <<Optional value not found in discovery>>
    search_domain_names = [
      "vcn.oraclevcn.com",
    ]
    #server_type = <<Optional value not found in discovery>>
    type = "SearchDomain"
  }
}
resource oci_core_default_route_table export_Default-Route-Table-for-vcn-20200918-0835 {
  display_name = "Default Route Table for OCI Arcade VCN"
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.export_vcn-20200918-0835.default_route_table_id
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.export_Internet-Gateway-vcn-20200918-0835.id
  }
}
resource oci_core_default_security_list export_Default-Security-List-for-vcn-20200918-0835 {
  display_name = "Default Security List for OCI Arcade VCN"
  egress_security_rules {
    #description = <<Optional value not found in discovery>>
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    #icmp_options = <<Optional value not found in discovery>>
    protocol  = "all"
    stateless = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  freeform_tags = {
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    icmp_options {
      code = "-1"
      type = "3"
    }
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "8080"
      min = "8080"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "8081"
      min = "8081"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "8082"
      min = "8082"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  manage_default_resource_id = oci_core_vcn.export_vcn-20200918-0835.default_security_list_id
}
resource oci_identity_api_key current_user_api_key {
  count = var.enable_api_key ? 1 : 0
  key_value = tls_private_key.public_private_key_pair.public_key_pem
  user_id = var.user_id
}