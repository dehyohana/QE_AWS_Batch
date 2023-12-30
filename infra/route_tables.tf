# Uncoment only if you don't have Internet Gateway

# Update the route tables to allow internet access for each subnet
# resource "aws_route" "subnet_routes" {
#   count                  = length(var.subnets_list)
#   route_table_id         = element(aws_route_table.my_route_table.*.id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.my_internet_gateway.id
# }
