<!-- Source: https://github.com/jdeanwallace/ansible-project-template -->

# {{ cookiecutter.ansible_project_name.replace('-', ' ').title() }} Project

This ansible project provisions the following VMs:
- `{{ cookiecutter.vm_slug }}` (`{{ cookiecutter.app_project_name }}`)

## Initial Local Setup

### Install Ansible
```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

### Generate Vault Key

For an existing project, please get the `{{ cookiecutter.ansible_project_name }}-vault` file from a team member. Otherwise, generate a new key using:
```bash
openssl rand -base64 2048 > ~/{{ cookiecutter.ansible_project_name }}-vault
```

### Create Vault Variables


For an existing project, these vault variables would already have been created. Otherwise, view, edit or create them using:
```bash
ansible-vault view|edit|create --vault-password-file ~/{{ cookiecutter.ansible_project_name }}-vault ./inventories/ENV/group_vars/GROUP/vault.yml
```

## Dev

### Setup

#### Download & Install VirtualBox

https://www.virtualbox.org/wiki/Downloads *(Avoid using a package manager)*

#### Download & Install Vagrant

https://www.vagrantup.com/downloads.html *(Avoid using a package manager)*

### Deploy

**{{ cookiecutter.vm_slug }}**
```bash
vagrant up {{ cookiecutter.vm_slug }} --provision
```

## Prod

### Setup
Apply the following steps to a newly created production server.

#### Add Admin User
```bash
# Create new user
sudo adduser --disabled-password --gecos "" admin
# Allow passwordless sudo access
sudo visudo
# Add this line: admin ALL=(ALL) NOPASSWD:ALL
```

#### Create SSH Deploy Keys

**{{ cookiecutter.vm_slug }}**

```bash
ssh REMOTE_USERNAME@{{ cookiecutter.vm_slug }}.example.com
sudo su - admin
ssh-keygen -t rsa -f ~/.ssh/{{ cookiecutter.app_project_name }}.id_rsa -C "admin@{{ cookiecutter.vm_slug }}.example.com"
cat ~/.ssh/{{ cookiecutter.app_project_name }}.id_rsa.pub
```

Add the public key to Github as a deployment key.

```bash
# Add to ~/.ssh/config file
Host {{ cookiecutter.app_project_name }}.github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/{{ cookiecutter.app_project_name }}.id_rsa
  IdentitiesOnly yes
```

```bash
# Test ssh connection
ssh -T git@{{ cookiecutter.app_project_name }}.github.com
```

### Deploy

**{{ cookiecutter.vm_slug }}**
```bash
ansible-playbook -i inventories/prod {{ cookiecutter.vm_slug }}.yml --limit {{ cookiecutter.vm_slug }}1 -e "ansible_ssh_user=REMOTE_USERNAME" --vault-password-file ~/{{ cookiecutter.ansible_project_name }}-vault -vv
```
