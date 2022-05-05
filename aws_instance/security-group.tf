resource "aws_security_group" "index-private-full-acces" {
    name = "all private ip access"
    description = "Add access for all private ip"
    vpc_id = var.vpc_id
    ingress = [
        {
        description      = "all private ip"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["00.0.0.0/0", "000.00.0.0/00", "000.000.0.0/00"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        },

        {
        description      = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        },

        {
        description      = "https"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        }
    ]

    egress = [
    {
        description      = "all private ip"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
    }
  ]
}
