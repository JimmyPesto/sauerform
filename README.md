# Sauerform

Did you ever want to host your personal Cube2 Sauerbraten game server but didn't want to take care of all the necessary steps to set it up?

Welcome to the Cube2 Sauerbraten Game Server Automation project! This open-source solution automates the process of setting up and deploying a Cube2 Sauerbraten game server on the Hetzner Cloud using Terraform, Ansible, and Docker Compose.

With this project, you can quickly and easily create your own Cube2 Sauerbraten game server in the cloud and start playing with friends or the wider gaming community. No more hassle of manual setup and configuration.

It deploys a [CX11 Cloud Server](https://docs.hetzner.com/de/cloud/servers/overview), creates a firewall with specified rules, sets up SSH keys for secure access, and triggers [Ansible](https://docs.ansible.com/ansible/latest/index.html) to perform server setup.

Special thanks goes to:
* [zanderwork.com](https://zanderwork.com/blog/hosting-a-sauerbraten-server/#server-setup)
* [GitHub captainGeech42/cube2srv](https://github.com/captainGeech42/cube2srv)
* [Docker Hub captaingeech/cube2srv](https://hub.docker.com/r/captaingeech/cube2srv)
* Some of the worst documented projects with a decent size, [Cube2 Sauberbraten](http://sauerbraten.org/).


# Features
* Terraform scripts for provisioning the required cloud infrastructure using [Terraform Hetzner Cloud Provider](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs).
  * [CX11 Cloud Server](https://docs.hetzner.com/de/cloud/servers/overview) with 1 vCPU and 2 GB of RAM, this affordable CX11 instance type offers a powerful setup that guarantees a great game experience.
* [Ansible](https://docs.ansible.com/ansible/latest/index.html) playbooks for server setup and management.
* Docker Compose for containerization of the game server.

# Pre-requisites
Before getting started with this project, ensure you have the following installed:

* Terraform (tested with v1.5.0)
* Ansible (tested with v2.11.2)
* [Registered Acoount at Hetzner Cloud](https://accounts.hetzner.com/signUp) and a [Payment Method](https://docs.hetzner.com/accounts-panel/accounts/payment-faq/)

# Configuration
1. Clone this repository to your local machine.
2. Install the necessary Terraform provider plugins by running `terraform init`.
3. Create a copy of the [terraform.tmpl.tfvars](terraform/terraform.tmpl.tfvars) file and save it as `terraform.tfvars` before modifying the following variables to match your requirements:
   * simply follow [this tutorial](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/) to generate your personal token `hcloud_token`
   * If you are not familiar with SSH keys, follow [Hetzners How to SSH](https://community.hetzner.com/tutorials/howto-ssh-key) to create a new key pair
     * enter your private key file as `hcloud_admin_priv_key_file`, eg. `~/.ssh/id_rsa`
     * enter your public key file as `hcloud_admin_priv_key_file`, eg. `~/.ssh/id_rsa.pub`
4. Create a copy of [server-init.tmpl.cfg](sauerbraten/server-init.tmpl.cfg) called `server-init.cfg` within the [sauerbraten](sauerbraten) subdirectry and edit it based on your wishes.
   * Take a look [here](https://zanderwork.com/blog/hosting-a-sauerbraten-server/#server-setup) to get some basic understanding of the available options.

# Usage
To deploy the infrastructure and perform the server setup:
1. Navigate to the [terraform/](terraform) subdirectory of the cloned repository on your local machine.
2. Run `terraform apply` to create the Hetzner Cloud server and firewall, and trigger Ansible for the server setup.
   * Confirm by typing `yes` when prompted.
3. Terraform will provision the infrastructure and output the IP address of the created server into [inventory.yml](ansible/inventory.yml) based on the template from [here](terraform/templates/inventory.tmpl).
4. Ansible will then be triggered by terraform to connect to the server using SSH and apply the defined [playbook](ansible/playbook.yml) based on the new inventory file.
5. You can now execute further Ansible commands or playbooks using the generated inventory file.
   * To keep your libraries on the servers host os up to date, you can use the command `ansible-playbook -i inventory.yml upgrade_playbook.yml` to run apt update and apt upgrade.
   * To update your game

# Cleanup

To destroy the Hetzner Cloud infrastructure:

1. Navigate to the [terraform/](terraform) subdirectory of the cloned repository on your local machine.
2. Run `terraform destroy` and confirm by typing `yes` when prompted.
3. Terraform will destroy the created resources, including the Cloud Server, Firewall, and associated SSH keys.

Please note that destroying the infrastructure will result **in the loss of any data stored on the Cloud Server**.

# Contributing

Contributions are welcome! Please feel free to submit a pull request if you spot any issues or have any improvements to suggest.