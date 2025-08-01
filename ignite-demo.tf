# ---------- Create Projects ----------
resource "zedcloud_project" "demo_project_zededa_1" {
  name            = "DEMO-ZED-CLUSTERING"
  title           = "DEMO-ZED-CLUSTERING"
  type            = "TAG_TYPE_PROJECT"
  tag_level_settings    {
    interface_ordering = "INTERFACE_ORDERING_ENABLED"
    flow_log_transmission   = "NETWORK_INSTANCE_FLOW_LOG_TRANSMISSION_ENABLED"
  }
  edgeview_policy {
      type          = "POLICY_TYPE_EDGEVIEW"
    edgeview_policy {
      access_allow_change = true
      edgeview_allow = true
      edgeviewcfg {
        app_policy {
          allow_app = true
        }
        dev_policy {
          allow_dev = true
        }
        jwt_info {
          disp_url = "zedcloud.gmwtus.zededa.net/api/v1/edge-view"
          allow_sec = 18000
          num_inst = 1
          encrypt = true
        }
        ext_policy {
          allow_ext = true
        }
      }
      max_expire_sec = 2592000
      max_inst = 3
    }
  }
}

# ---------- Create ATL Local Datastore ----------
resource "zedcloud_datastore" "demo_infra_atl_ds" {
  ds_fqdn = "http://192.168.0.101:88"
  ds_type = "DATASTORE_TYPE_HTTP"
  name    = "TF-ATL-DS"
  title   = "TF-ATL-DS"
  ds_path = "iso"
  project_access_list = []
}

# ---------- Create Azure Datastore ----------
resource "zedcloud_datastore" "demo_az_blob_ds" {
  name    = "TF-AD-AZURE-DS"
  title   = "TF-AD-AZURE-DS"
  api_key = var.azure_blob_api_username
  ds_fqdn = var.azure_blob_url
  secret {
    api_passwd = var.azure_blob_password
  }
  ds_type = var.datastore_type

  ds_path = var.azure_ds_path
  project_access_list = []
}


# ---------- Create ATL Ubuntu Image ----------
resource "zedcloud_image" "infra_ubuntu_cloud_image" {
  datastore_id = zedcloud_datastore.demo_infra_atl_ds.id
  image_type = "IMAGE_TYPE_APPLICATION"
  image_arch = "AMD64"
  image_format = "QCOW2"
  image_sha256 = "92d2c4591af9a82785464bede56022c49d4be27bde1bdcf4a9fccc62425cda43"
  image_size_bytes = 613725184
  name = "Ubuntu_Cloud_Images_Noble"
  title = "Ubuntu_Cloud_Images_Noble"
  project_access_list = []
  image_rel_url = "noble-server-cloudimg-amd64.img"
}

# ---------- Create FW FIREWALL Image ----------
resource "zedcloud_image" "tf_demo_fw_image" {
  datastore_id = zedcloud_datastore.demo_infra_atl_ds.id
  image_type = "IMAGE_TYPE_APPLICATION"
  image_arch = "AMD64"
  image_format = "QCOW2"
  image_sha256 = "0e275df6f35b3139d4988afcf4ddd0e3cc9fcf88320877efe0dfd17febe75147"
  image_size_bytes = 100728832
  name = "fortios-7.4.3.qcow2"
  title = "fortios-7.4.3.qcow2"
  project_access_list = []
  image_rel_url = "fortios-7.4.3.qcow2"
}

# ---------- Creating EVE Network Port Config per Project ----------
resource "zedcloud_network" "demo_edge_node_net" {
  name        = "DEMO-EVE-NET"
  title       = "DEMO-EVE-NET"
  description = "Network (DHCP)"
  enterprise_default = false
  kind        = "NETWORK_KIND_V4"
  ip {
    dhcp = "NETWORK_DHCP_TYPE_CLIENT"
  }
  project_id = zedcloud_project.demo_project_zededa_1.id
}

# # ---------- Create Brand and Model----------
resource "zedcloud_brand" "demo_brand_intel_nuc" {
  name        = "TF-INTEL-NUC"
  title       = "TF-INTEL-NUC"
  origin_type = "ORIGIN_LOCAL"
  logo        = {
    url       = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Intel_logo_2023.svg/250px-Intel_logo_2023.svg.png"
  }
}

resource "zedcloud_model" "demo_inte_nuc_model" {
  name          = "Intel-HUC-i7-12vCPU-32G-Mem"
  title         = "Intel-HUC-i7-12vCPU-32G-Mem"
  brand_id      = zedcloud_brand.demo_brand_intel_nuc.id
  origin_type   = "ORIGIN_LOCAL"
  state         =  "SYS_MODEL_STATE_ACTIVE"
  type          = "AMD64"
  attr          =  {
    memory      = "32G"
    storage     = "238G"
    Cpus        = "12"
  }
 io_member_list {
      ztype         = "IO_TYPE_HDMI"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "VGA"
      logicallabel  = "VGA"
      cost          = 0
      assigngrp     = ""
      phyaddrs      = { 
        Ifname = "VGA"
        PciLong = "0000:00:02.0" }
    }
  io_member_list {
      ztype        = "IO_TYPE_USB_CONTROLLER"
      usage        = "ADAPTER_USAGE_APP_SHARED"
      phylabel     = "USB"
      assigngrp    = "group6"
      phyaddrs     = { 
        Ifname     = "USB"
        PciLong    = "0000:00:14.0" }
      logicallabel = "USB"
      cost         = 0
    }
  io_member_list {
      ztype        = "IO_TYPE_USB_CONTROLLER"
      usage        = "ADAPTER_USAGE_APP_SHARED"
      phylabel     = "USB"
      assigngrp    = "group24"
      phyaddrs     = { 
        Ifname     = "USB1"
        PciLong    = "0000:3b:00.0" }
      logicallabel = "USB1"
      cost         = 0
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "eth0"
      logicallabel  = "eth0"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth0"
      phyaddrs      = { 
        Ifname = "eth0"
        PciLong = "0000:00:1f.6" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "eth1"
      logicallabel  = "eth1"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth1"
      phyaddrs      = { 
        Ifname = "eth1"
        PciLong = "0000:70:00.0" }
    }
  io_member_list {
      ztype         = "IO_TYPE_WLAN"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "wlan0"
      logicallabel  = "wlan0"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "wlan0"
      phyaddrs      = { 
        Ifname = "wlan0"
        PciLong = "0000:04:00.0" }
    }
}

# # ---------- Create Edge Nodes ---------------------------
resource "zedcloud_edgenode" "demo_edge_node_1" {
  name           = "ZED-NUC-EDGE-NODE-1"
  title          = "ZED-NUC-EDGE-NODE-1"
  project_id     = zedcloud_project.demo_project_zededa_1.id
  model_id       = zedcloud_model.demo_inte_nuc_model.id
  onboarding_key = var.onboarding_key
  serialno       = var.device_serial
  description    = "ZED Clustering Demo"
  admin_state    = "ADMIN_STATE_ACTIVE"
  config_item {
    key          = "debug.enable.ssh"
    string_value = var.ssh_pub_key
    bool_value   = false
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }
  config_item {
    bool_value    = false
    float_value   = 0
    key           = "debug.disable.dhcp.all-ones.netmask"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    key          = "debug.enable.console"
    string_value = true
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
    }
  config_item {
    bool_value    = true
    float_value   = 0
    key           = "debug.enable.vga"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    bool_value    = true
    float_value   = 0
    key           = "debug.enable.usb"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    key          = "process.cloud-init.multipart"
    string_value = "true"
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
    }
  edgeviewconfig {
    generation_id = 0
    token         = var.edgeview_token
    app_policy {
      allow_app = true
    }
    dev_policy {
      allow_dev = true
    }
    ext_policy {
      allow_ext = true
    }
    jwt_info {
      allow_sec  = 18000
      disp_url   = "zedcloud.gmwtus.zededa.net/api/v1/edge-view"
      encrypt    = true
      expire_sec = "0"
      num_inst   = 3
    }
  }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM1"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM2"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM3"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "eth0"
        netname    = zedcloud_network.demo_edge_node_net.name
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "eth1"
        netname    = ""
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "USB"
        netname    = ""
        tags       = {}
    }
}

resource "zedcloud_edgenode" "demo_edge_node_2" {
  name           = "ZED-NUC-EDGE-NODE-2"
  title          = "ZED-NUC-EDGE-NODE-2"
  project_id     = zedcloud_project.demo_project_zededa_1.id
  model_id       = zedcloud_model.demo_inte_nuc_model.id
  onboarding_key = var.onboarding_key
  serialno       = var.device_serial2
  description    = "ZED Clustering Demo"
  admin_state    = "ADMIN_STATE_ACTIVE"
  config_item {
    key          = "debug.enable.ssh"
    string_value = var.ssh_pub_key
    bool_value   = false
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }
  config_item {
    bool_value    = false
    float_value   = 0
    key           = "debug.disable.dhcp.all-ones.netmask"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    key          = "debug.enable.console"
    string_value = true
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
    }
  config_item {
    bool_value    = true
    float_value   = 0
    key           = "debug.enable.vga"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    bool_value    = true
    float_value   = 0
    key           = "debug.enable.usb"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    key          = "process.cloud-init.multipart"
    string_value = "true"
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
    }
  edgeviewconfig {
    generation_id = 0
    token         = var.edgeview_token
    app_policy {
      allow_app = true
    }
    dev_policy {
      allow_dev = true
    }
    ext_policy {
      allow_ext = true
    }
    jwt_info {
      allow_sec  = 18000
      disp_url   = "zedcloud.gmwtus.zededa.net/api/v1/edge-view"
      encrypt    = true
      expire_sec = "0"
      num_inst   = 3
    }
  }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM1"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM2"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM3"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "eth0"
        netname    = zedcloud_network.demo_edge_node_net.name
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_APP_SHARED"
        intfname   = "eth1"
        netname    = ""
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_APP_SHARED"
        intfname   = "wlan0"
        netname    = ""
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_APP_SHARED"
        intfname   = "USB"
        netname    = ""
        tags       = {}
    }
}

resource "zedcloud_edgenode" "demo_edge_node_3" {
  name           = "ZED-NUC-EDGE-NODE-3"
  title          = "ZED-NUC-EDGE-NODE-3"
  project_id     = zedcloud_project.demo_project_zededa_1.id
  model_id       = zedcloud_model.demo_inte_nuc_model.id
  onboarding_key = var.onboarding_key
  serialno       = var.device_serial3
  description    = "ZED Clustering Demo"
  admin_state    = "ADMIN_STATE_ACTIVE"
  config_item {
    key          = "debug.enable.ssh"
    string_value = var.ssh_pub_key
    bool_value   = false
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }
  config_item {
    bool_value    = false
    float_value   = 0
    key           = "debug.disable.dhcp.all-ones.netmask"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    key          = "debug.enable.console"
    string_value = true
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
    }
  config_item {
    bool_value    = true
    float_value   = 0
    key           = "debug.enable.vga"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    bool_value    = true
    float_value   = 0
    key           = "debug.enable.usb"
    string_value  = true
    uint32_value  = 0
    uint64_value  = 0
    }
  config_item {
    key          = "process.cloud-init.multipart"
    string_value = "true"
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
    }
  edgeviewconfig {
    generation_id = 0
    token         = var.edgeview_token
    app_policy {
      allow_app = true
    }
    dev_policy {
      allow_dev = true
    }
    ext_policy {
      allow_ext = true
    }
    jwt_info {
      allow_sec  = 18000
      disp_url   = "zedcloud.gmwtus.zededa.net/api/v1/edge-view"
      encrypt    = true
      expire_sec = "0"
      num_inst   = 3
    }
  }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM1"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM2"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "COM3"
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "eth0"
        netname    = zedcloud_network.demo_edge_node_net.name
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_MANAGEMENT"
        intfname   = "eth1"
        netname    = ""
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_APP_SHARED"
        intfname   = "wlan0"
        netname    = ""
        tags       = {}
    }
    interfaces {
        cost       = 0
        intf_usage = "ADAPTER_USAGE_APP_SHARED"
        intfname   = "USB"
        netname    = ""
        tags       = {}
    }
}

#---------- Create network Instances ----------
resource "zedcloud_network_instance" "demo_wan" {
  name = "mgt"
  title = "mgt"
  kind = "NETWORK_INSTANCE_KIND_LOCAL"
  type = "NETWORK_INSTANCE_DHCP_TYPE_V4"
  port = "eth0"
  device_id = zedcloud_edgenode.demo_edge_node_1.id
  ip {
    dhcp_range {
    end = "10.1.0.30"
    start = "10.1.0.20"
  }
    dns = [
      "1.1.1.1"
  ]
    domain = ""
    gateway = "10.1.0.1"
    ntp = "64.246.132.14"
    subnet = "10.1.0.0/24"
  }
}

resource "zedcloud_network_instance" "demo_lan_1" {
  name = "LAN-1"
  title = "LAN-1"
  kind = "NETWORK_INSTANCE_KIND_SWITCH"
  type = "NETWORK_INSTANCE_DHCP_TYPE_UNSPECIFIED"
  port = ""
  device_id = zedcloud_edgenode.demo_edge_node_1.id
 depends_on = []
}

resource "zedcloud_network_instance" "demo_lan_2" {
  name = "LAN-2"
  title = "LAN-2"
  kind = "NETWORK_INSTANCE_KIND_SWITCH"
  type = "NETWORK_INSTANCE_DHCP_TYPE_UNSPECIFIED"
  port = ""
  device_id = zedcloud_edgenode.demo_edge_node_1.id
 depends_on = []
}

resource "zedcloud_network_instance" "demo_lan_3" {
  name = "LAN-3"
  title = "LAN-3"
  kind = "NETWORK_INSTANCE_KIND_SWITCH"
  type = "NETWORK_INSTANCE_DHCP_TYPE_UNSPECIFIED"
  port = ""
  device_id = zedcloud_edgenode.demo_edge_node_1.id
 depends_on = []
}

#---------- Create FW App ----------
resource "zedcloud_application" "tf_edge_fw_app" {
  name = "TF-FW-APP"
  title = "TF-FW-APP"
  networks = 4
  manifest {
    ac_kind = "VMManifest"
    ac_version = "1.2.0"
    name = "TF-FW-APP"
    resources {
      name = "cpus"
      value = 4
    }
    resources {
      name  = "memory"
      value = 8777216
    }
  owner {
    user = "Manny Calero"
    company = "Zededa"
    website = "www.zededa.com"
    email = "manny@zededa.com"
  }
  desc {
    app_category = "APP_CATEGORY_UNSPECIFIED"
    category = "APP_CATEGORY_SECURITY"
     logo        = {
       url       = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Firewall.png/250px-Firewall.png" 
      }
    } 
  images {
    imagename = zedcloud_image.tf_demo_fw_image.name
    imageid = zedcloud_image.tf_demo_fw_image.id
    imageformat = "QCOW2"
    cleartext = false
    drvtype = "HDD"
    ignorepurge = true
    maxsize = 41943040
    target = "Disk"
  }
  images {
    imagename = var.forti_iso_name
    imageid = var.forti_iso_id
    imageformat = "RAW"
    cleartext = false
    drvtype = "CDROM"
    ignorepurge = false
    maxsize = 1048576
    target = "Disk"
    }
  interfaces {
    name = "eth0"
    type = ""
    directattach = false
    privateip = false
      acls {
        matches { ### Outbound rule
          type = "ip"
          value = "0.0.0.0/0"
      }
    }
    acls { 
      matches { ### Inbound rules & port mappings
        type = "ip"
        value = "0.0.0.0/0"
      }
      actions {
        portmap = true
        portmapto {
          app_port = 443 #Internal App port
        }
      }
      matches {
        type = "protocol"
        value = "tcp"
      }
      matches {
        type = "lport"
        value = 10443  ### External Edge node port
     }
      matches {
        type = "ip"
        value = "0.0.0.0/0"
     }
    }
    acls { 
      matches { ### Inbound rules & port mappings
        type = "ip"
        value = "0.0.0.0/0"
      }
      actions {
        portmap = true
        portmapto {
          app_port = 22 #Internal App port
        }
      }
      matches {
        type = "protocol"
        value = "tcp"
      }
      matches {
        type = "lport"
        value = 10022  ### External Edge node port
     }
      matches {
        type = "ip"
        value = "0.0.0.0/0"
     }
    }
   } 
  interfaces {
    name = "eth1"
    type = ""
    directattach = false
    privateip = false
      acls {
        matches { ### Outbound rule
          type = "ip"
          value = "0.0.0.0/0"
      }
    }
   }
  interfaces {
    name = "eth2"
    type = ""
    directattach = false
    privateip = false
      acls {
        matches { ### Outbound rule
          type = "ip"
          value = "0.0.0.0/0"
        }
      }
   }
  interfaces {
    name = "eth3"
    type = ""
    directattach = false
    privateip = false
      acls {
        matches { ### Outbound rule
          type = "ip"
          value = "0.0.0.0/0"
        }
      }
   }
  vmmode = "HV_HVM"
  enablevnc = true
  resources {
    name = "storage"
    value = 40971520
  }
  configuration {
    custom_config {
      add = true
      name = "cloud-config"
      override = true
      template = ""      
    }
   }
  app_type = "APP_TYPE_VM" 
  deployment_type = "DEPLOYMENT_TYPE_STAND_ALONE"
  cpu_pinning_enabled = false
 }
  user_defined_version = "11.2.5"
  origin_type = "ORIGIN_LOCAL"
  project_access_list = []
}

#---------- Create Ubuntu App ----------
resource "zedcloud_application" "tf_ubuntu_app" {
  name = "TF-VM-APP"
  title = "TF-VM-APP"
  networks = 1
  manifest {
    ac_kind = "VMManifest"
    ac_version = "1.2.0"
    name = "TF-VM-APP"
    app_type = "APP_TYPE_VM"
    deployment_type = "DEPLOYMENT_TYPE_STAND_ALONE"
    cpu_pinning_enabled = false
    resources {
      name = "cpus"
      value = 2
    }
    resources {
      name  = "memory"
      value = 2097152
    }
  owner {
    user        = "Manny Calero"
    company     = "Zededa"
    website     = "www.zededa.com"
    email       = "manny@zededa.com"
  }
  desc {
    app_category = "APP_CATEGORY_OPERATING_SYSTEM"
    category     = "APP_CATEGORY_OPERATING_SYSTEM"
     logo        = {
       url       = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Ubuntu-logo-2022.svg/250px-Ubuntu-logo-2022.svg.png" 
      }
    } 
  images {
    imagename = zedcloud_image.infra_ubuntu_cloud_image.name
    imageid = zedcloud_image.infra_ubuntu_cloud_image.id
    imageformat = "QCOW2"
    cleartext = false
    drvtype = "HDD"
    ignorepurge = true
    maxsize = 20971520
    target = "Disk"
    }
  interfaces {
    name = "eth0"
    type = ""
    directattach = false
    privateip = false
   acls {
      matches { ### Outbound rule 
        type = "ip"
        value = "0.0.0.0/0"
      }
    }
   } 
  vmmode = "HV_HVM"
  enablevnc = true

  configuration {
    custom_config {
      add = true
      name = "cloud-config"
      override = true
      template = ""      
    }
   }
    resources {
      name = "storage"
      value = 20097152
    }
 }
  user_defined_version = "24.04"
  origin_type = "ORIGIN_LOCAL"
  project_access_list = []
}

# ---------- Create K3S App ----------
resource "zedcloud_application" "tf_k3s_runtime_app" {
  name = "TF-K3S-APP"
  title = "TF-K3S-APP"
  networks = 2
  manifest {
    ac_kind = "VMManifest"
    ac_version = "1.2.0"
    name = "TF-K3S-APP"
    app_type = "APP_TYPE_VM"
    deployment_type = "DEPLOYMENT_TYPE_STAND_ALONE"
    cpu_pinning_enabled = false
    resources {
      name = "cpus"
      value = 8
    }
    resources {
      name  = "memory"
      value = 8097152
    }
  owner {
    user        = "Manny Calero"
    company     = "Zededa"
    website     = "www.zededa.com"
    email       = "manny@zededa.com"
  }
  desc {
    app_category = "APP_CATEGORY_OPERATING_SYSTEM"
    category     = "APP_CATEGORY_OPERATING_SYSTEM"
     logo        = {
       url       = "https://k3s.io/img/k3s-logo-light.svg" 
      }
    } 
  images {
    imagename = zedcloud_image.infra_ubuntu_cloud_image.name
    imageid = zedcloud_image.infra_ubuntu_cloud_image.id
    imageformat = "QCOW2"
    cleartext = false
    drvtype = "HDD"
    ignorepurge = false
    maxsize = 30971520
    target = "Disk"
    }
  interfaces {
    name = "eth0"
    type = ""
    directattach = false
    privateip = false
   acls {
      matches { ### Outbound rule 
        type = "ip"
        value = "0.0.0.0/0"
      }
    }
   } 
    interfaces {
      name = "eth1"
      type = ""
      directattach = false
      privateip = false
    acls {
        matches { ### Outbound rule 
          type = "ip"
          value = "0.0.0.0/0"
        }
      }
    acls { 
      matches { ### Inbound rules & port mappings
        type = "ip"
        value = "0.0.0.0/0"
      }
      actions {
        portmap = true
        portmapto {
          app_port = 30500 #Internal App port
        }
      }
      matches {
        type = "protocol"
        value = "tcp"
      }
      matches {
        type = "lport"
        value = 30500  ### External Edge node port
     }
      matches {
        type = "ip"
        value = "0.0.0.0/0"
     }
    }
    acls { 
      matches { ### Inbound rules & port mappings
        type = "ip"
        value = "0.0.0.0/0"
      }
      actions {
        portmap = true
        portmapto {
          app_port = 22 #Internal App port
        }
      }
      matches {
        type = "protocol"
        value = "tcp"
      }
      matches {
        type = "lport"
        value = 1022  ### External Edge node port
     }
      matches {
        type = "ip"
        value = "0.0.0.0/0"
     }
    }
   } 
  vmmode = "HV_HVM"
  enablevnc = true

  configuration {
    custom_config {
      add = true
      name = "cloud-config"
      override = true
      template = ""      
    }
   }
    resources {
      name = "storage"
      value = 20097152
    }
 }
  user_defined_version = "24.04"
  origin_type = "ORIGIN_LOCAL"
  project_access_list = []
}

# =================== Instances ===========================
# ---------- Create FW VM Deploy ----------
resource "zedcloud_application_instance" "tf_fw_deploy" {
  name              = "TF-FW-INSTANCE"
  title             = "TF-FW-INSTANCE"
  project_id        = zedcloud_project.demo_project_zededa_1.id
  app_id            = zedcloud_application.tf_edge_fw_app.id
  activate          = true
  custom_config {
    add             = true
    allow_storage_resize = true
    field_delimiter = "@@@"
    name            = "cloud-config"
    override        = true
    template        = ""
  }
  device_id         = zedcloud_edgenode.demo_edge_node_1.id
  drives {
    imagename       = zedcloud_image.tf_demo_fw_image.name
    cleartext       = false
    ignorepurge     = true
    maxsize         = 40971520
    preserve        = false
    target          = "Disk"
    drvtype         = "HDD"
    readonly        = false
  }
   drives {
    imagename       = var.forti_iso_name
    cleartext       = false
    ignorepurge     = true
    maxsize         = 10650112
    preserve        = false
    target          = "Disk"
    drvtype         = "CDROM"
    readonly        = true
  }
  interfaces {
    intfname = "eth0"
    intforder = 1
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = "02:16:3e:f8:bc:40"
    netinstname = zedcloud_network_instance.demo_wan.name
    privateip = false
  }
  interfaces {
    intfname = "eth1"
    intforder = 2
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_lan_1.name
    privateip = false
  }
  interfaces {
    intfname = "eth2"
    intforder = 3
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_lan_2.name
    privateip = false
  }
  interfaces {
    intfname = "eth3"
    intforder = 4
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_lan_3.name
    privateip = false
  }
}

# Local-exec provisioner to query the firewall endpoint and log progress
resource "null_resource" "health_check" {
  depends_on = [zedcloud_application_instance.tf_pan_deploy]

  provisioner "local-exec" {
    command     = "bash ./cinit/health_check.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}

# ---------- Create Ubuntu VM1 Deploy ----------
resource "zedcloud_application_instance" "tf_vm_1_deploy" {
  name              = "VM-1"
  title             = "VM-1"
  project_id        = zedcloud_project.demo_project_ignite_1.id
  app_id            = zedcloud_application.tf_ubuntu_app.id
  activate          = true
  custom_config {
    add             = true
    allow_storage_resize = true
    field_delimiter = "@@@"
    name            = "cloud-config"
    override        = true
    template        = base64encode(file("./cinit/vm1-cloud-init.txt"))
  }
  device_id         = zedcloud_edgenode.infra_ignite_pan_node_1.id
  drives {
    imagename       = zedcloud_image.infra_sjc_lab_ubuntu.name
    cleartext       = false
    ignorepurge     = true
    maxsize         = 20000000
    preserve        = false
    target          = "Disk"
    drvtype         = "HDD"
    readonly        = false
  }
  interfaces {
    intfname = "eth0"
    intforder = 1
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_ignite_pan_lan1.name
    privateip = false
  }
  depends_on = [null_resource.health_check]
}

# ---------- Create Ubuntu VM1 Deploy ----------
resource "zedcloud_application_instance" "tf_vm_2_deploy" {
  name              = "VM-2"
  title             = "VM-2"
  project_id        = zedcloud_project.demo_project_ignite_1.id
  app_id            = zedcloud_application.tf_ubuntu_app.id
  activate          = true
  custom_config {
    add             = true
    allow_storage_resize = true
    field_delimiter = "@@@"
    name            = "cloud-config"
    override        = true
    template        = base64encode(file("./cinit/vm2-cloud-init.txt"))
  }
  device_id         = zedcloud_edgenode.infra_ignite_pan_node_1.id
  drives {
    imagename       = zedcloud_image.infra_sjc_lab_ubuntu.name
    cleartext       = false
    ignorepurge     = true
    maxsize         = 20000000
    preserve        = false
    target          = "Disk"
    drvtype         = "HDD"
    readonly        = false
  }
  interfaces {
    intfname = "eth0"
    intforder = 1
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_ignite_pan_lan2.name
    privateip = false
  }
  depends_on = [null_resource.health_check]
}

# ---------- Create k3s App Runtime ----------
resource "zedcloud_application_instance" "tf_k3s_1_deploy" {
  name              = "K3S-site-1"
  title             = "K3S-site-1"
  project_id        = zedcloud_project.demo_project_ignite_1.id
  app_id            = zedcloud_application.tf_k3s_runtime_app.id
  activate          = true
  custom_config {
    add             = true
    allow_storage_resize = true
    field_delimiter = "@@@"
    name            = "cloud-config"
    override        = true
    template        = base64encode(file("./cinit/k3s_1.txt"))
  }
  device_id         = zedcloud_edgenode.infra_ignite_pan_node_1.id
  drives {
    imagename       = zedcloud_image.infra_sjc_lab_ubuntu.name
    cleartext       = false
    ignorepurge     = true
    maxsize         = 20000000
    preserve        = false
    target          = "Disk"
    drvtype         = "HDD"
    readonly        = false
  }
  interfaces {
    intfname = "eth0"
    intforder = 1
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_ignite_pan_lan2.name
    privateip = false
  }
  interfaces {
    intfname = "eth1"
    intforder = 2
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = "10.10.0.50"
    macaddr = "a2:10:88:b9:69:ed"
    netinstname = zedcloud_network_instance.demo_ignite_pan_mgmt_1.name
    privateip = false
  }
  depends_on = [null_resource.health_check]
}

# Output to remind user how to monitor the log
output "monitor_progress" {
  value = "Progress is logged to 'health_check.log'. Run 'tail -f health_check.log' to monitor in real time."
}

resource "zedcloud_application_instance" "tf_comp_vision_deploy_sjc" {
  name              = "TF-COMP-VISION-APP"
  title             = "TF-COMP-VISION-APP"
  project_id        = zedcloud_project.demo_project_zededa_1.id
  app_id            = zedcloud_application.demo_comp_vision_app.id
  activate          = true
  custom_config {
    add             = true
    allow_storage_resize = true
    field_delimiter = "@@@"
    name            = "cloud-config"
    override        = true
    #template        = base64encode(file("./cinit/comp-vision-app.txt"))
  }
  device_id         = zedcloud_edgenode.demo_edge_node_1.id
  drives {
    imagename       = zedcloud_image.demo_retail_image.name
    cleartext       = false
    ignorepurge     = true
     maxsize        = 20097152
    preserve        = false
    target          = "Disk"
    drvtype         = "HDD"
    readonly        = false
  }
  interfaces {
    intfname = "eth0"
    intforder = 1
    directattach = false
    access_vlan_id = 0
    default_net_instance = false
    ipaddr = ""
    macaddr = ""
    netinstname = zedcloud_network_instance.demo_net_1.name
    privateip = false
  }
}


variable "zedcloud_url" { type = string }

variable "zedcloud_token" { type = string }

variable "device_serial" { 
  type = string
  sensitive = true
  default = "<serial 1>"
  }

variable "device_serial2" { 
  type = string
  sensitive = true
  default = "<serial 2>"
  }

variable "device_serial3" { 
  type = string
  sensitive = true
  default = "<serial 3>"
  }

variable "docker_hub_user" { 
  type = string
  sensitive = true
  default = "zedmanny"
  }


variable "docker_hub_secret" { 
  type = string
  sensitive = true
  default = "<scrubbed>"
  }

# Variable for project names
variable "regions" {
  type    = list(string)
  default = []
  description = "List of region names"
}

# Define variables for reusability
variable "num_instances_per_region" {
  default = 1
}

variable "base_uuid_prefix" {
  default = "tf_region"
}

# Define base suffix (hex) per region to ensure unique serials
variable "region_base_suffix_map" {
  default = {
    north_east = "000000000000"
    south_east = "000000100000"
    north_west = "000000200000"
    south_west = "000000300000"
  }
}

variable "onboarding_key" {
  default = "<scrubbed>"
  sensitive = true
}

variable "forti_iso_name" {
  default = "forti-bootstrap.iso"
}

variable "forti_iso_id" {
  default = "c56fccc2-420b-46dd-a241-64c23c082181"
}

####Azure Blob
variable "azure_blob_url" {
    description = "Azure blob URL"
    type        = string
    default     = "https://seblobstore.blob.core.windows.net"
}

variable "azure_blob_api_username" {
    description = "API Key - or Username"
    type        = string
    sensitive   = true
}

variable "azure_blob_password" {
    description = "This is the passkey for Azure blob"
    type        = string
    sensitive   = true

}

variable "azure_ds_path" {
    description = "Path to blob"
    type        = string
    default     = "demo-blob"
    sensitive = true
}

variable "datastore_type" {
    description = "Zededa datastore type"
    type        = string
    default     = "DATASTORE_TYPE_AZUREBLOB"
}

variable "ssh_pub_key" {
  default = "<ssh pub key"
  sensitive = true
}

variable "edgeview_token" {
  default = "Zed session token"
  sensitive = true
}

num_instances_per_region = 1
zedcloud_url = "gmwtus"
zedcloud_token = "<Zed session token>"
azure_blob_api_username = "seblobstore"
azure_blob_password = "<scrubbed blob key>"
regions = ["demo"]

