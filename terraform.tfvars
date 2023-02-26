# Para pasar variables se puede usar este archivo
# o se puede usar variables de entorno TF_VAR_*
# o al ejecutar el apply se puede pasar con -var="variable=valor"
# o al ejecutar el apply se puede pasar con -var-file="archivo.tfvars"
# https://www.terraform.io/docs/configuration/variables.html#environment-variables

project      = "miProject"
billing_code = "laBill"
vpc_cidr_block = {
  dev = "10.0.0.0/16"
  uat = "10.1.0.0/16"
  prd = "10.2.0.0/16"
}

vpc_subnet_count = {
  dev = 2
  uat = 2
  prd = 3
}

instance_type = {
  dev = "t4g.micro"
  uat = "t4g.small"
  prd = "t4g.medium"
}

instances_nginx_servers_count = {
  dev = 2
  uat = 4
  prd = 6
}