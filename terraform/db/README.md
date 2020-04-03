# Zulu Postgres

## Terraform

#### Requisitos:

* [Terraform](https://www.terraform.io) 0.12.x o superior
* [Token](https://www.hetzner.com/cloud) hetzner.com


En la raíz del proyecto genera una llave SSH (si ya tiene la llave SSH ignore este paso), nombrándola `my_ssh_key`:

``` shell
$ ssh-keygen -t rsa -b 4096 -C "my_ssh_key"
Generating public/private rsa key pair.
Enter file in which to save the key (/path/.ssh/id_rsa): my_ssh_key
```

Agregue el token generado en hetzner al archivo `terraform.tfvars`
``` shell
$ cat terraform.tfvars
hcloud_token=""
```

Ejecute `terraform init` y `terraform plan` para verificar que todo este en orden:
``` shell
$ cd terraform/db
$ terraform init
```
Si todo esta en orden, ejecuta la creación de la instancia:

``` shell
$ terraform apply
```

Terraform se encargará de subir la llave SSH, crear el servidor, crear una red privada e instalar postgres
