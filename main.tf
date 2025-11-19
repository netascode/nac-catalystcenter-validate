terraform {
  required_providers {
    catalystcenter = {
      source  = "CiscoDevNet/catalystcenter"
      version = "0.3.3"
    }
  }
}

provider "catalystcenter" {
  username    = "demo"
  password    = "demo1234!"
  url         = "https://dcloud-catalyst-center-inst-lon.cisco.com/"
  max_timeout = 30
}

module "catalyst_center" {
  source  = "netascode/nac-catalystcenter/catalystcenter"
  version = "0.2.0"

  yaml_directories      = ["data/"]
  templates_directories = ["templates/"]
}