data "aws_availability_zones" "available" {}
# The usage of the specific kubernetes.io/cluster/* resource tags below are required for EKS and Kubernetes to discover and manage networking resources.
resource "aws_vpc" "k8s" {
  cidr_block = "${var.vpc_cidr}"

  tags = "${
    map(
     "Name", "EKS-vpc",
     "kubernetes.io/cluster/${var.env}-k8-cluster", "shared",
    )
  }"
}

resource "aws_subnet" "k8s" {

  count             = "${length(data.aws_availability_zones.available.names)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.subnet_cidrs, count.index)}"
  vpc_id            = "${aws_vpc.k8s.id}"

  tags = "${
    map(
     "Name", "eks-subnet-${count.index}",
     "kubernetes.io/cluster/${var.env}-k8-cluster", "shared",
    )
  }"
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = "${aws_vpc.k8s.id}"

  tags {
    Name = "k8s-ig"
  }
}

resource "aws_route_table" "k8s" {
  vpc_id = "${aws_vpc.k8s.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.k8s.id}"
  }
}

resource "aws_route_table_association" "k8s" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${aws_subnet.k8s.*.id[count.index]}"
  route_table_id = "${aws_route_table.k8s.id}"
}
