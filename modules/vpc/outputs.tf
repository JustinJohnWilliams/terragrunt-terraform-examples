output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = {
    for zone, subnet in aws_subnet.private :
    zone => {
      cidr = subnet.cidr_block
      id   = subnet.id
    }
  }
}

output "public_subnets" {
  value = {
    for zone, subnet in aws_subnet.public :
    zone => {
      cidr = subnet.cidr_block
      id   = subnet.id
    }
  }
}

output "nat_gateway" {
  value = {
    for zone, nat in aws_nat_gateway.nat :
    zone =>
    {
      public_ip = nat.public_ip
      subnet_id = nat.subnet_id
    }
  }
}

output "eip" {
  value = {
    for zone, eip in aws_eip.nat
    : zone => { "ip" : eip.public_ip }
  }
}
