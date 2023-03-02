terraform {
  source = "../../../../../modules/vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name                = "My-VPC"
  vpc_network_address = "10.100"
}