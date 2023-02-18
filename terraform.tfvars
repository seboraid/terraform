# Para pasar variables se puede usar este archivo
# o se puede usar variables de entorno TF_VAR_*
# o al ejecutar el apply se puede pasar con -var="variable=valor"
# o al ejecutar el apply se puede pasar con -var-file="archivo.tfvars"
# https://www.terraform.io/docs/configuration/variables.html#environment-variables

project = "miProject"
billing_code = "laBill"