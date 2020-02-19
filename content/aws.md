# Deploy on AWS

Here are instructions of installing the enterprise workshop, see below for the different systems you provision for the lab.

![Overview of labs](images/overview.png)

# Pre-requisites

## Planning/sizing the environment
For the lab to work, you need to provision 2 Red Hat Enterprise Linux servers and 1 Windows system per student in the lab.

All users share the same Active Directory server. 

## General preparations
These instructions guide you how to let Ansible provision the environment to Amazon AWS. All installation material is in ```ansible/``` -directory, instructions assume you are working in that directory. Start with cloning this repository, moving into working directory, and adding your ssh key to ssh-agent for Ansible to use it:

```
git clone https://github.com/RedHatNordicsSA/linux4win.git
cd linux4win/ansible
ssh-add /path/to/your/amazon-ssh-key-file.pem
```

Export the AWS credentials (without this, the ec2.py inventory will bail out).
```
export AWS_ACCESS_KEY_ID=asdfasdfasdfasdfasdf
export AWS_SECRET_ACCESS_KEY='the-keyasdfasdfasdfasdf'
```


## Install Ansible

This setup was tested at the time of writing this README with Ansible version 2.9.x
To install Ansible follow [Ansible install guidance](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for your favourite OS, Linux :) .

## Ansible dynamic inventory

Before running the installer, you need to install boto Python modules on your Ansible machine using [the Ansible AWS documentation](http://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html).

Install the boto library using python pip, as follows:
```
sudo pip install boto
sudo pip install boto3
```

## Known issues
None yet

## Set parameters to Ansible variables file

Playbooks expect file ```ansible/vars/vars.yml``` to contain settings your personal AWS credentials, machine AMI image and some other parameters. Copy ```ansible/vars/vars-example.yml``` and fill it with your settings. It is recommended to use Ansible Vault to encrypt your credentials.

## Encrypting credentials with Ansible Vault

Put password of your choice into a text file. In this example ```ansible/vault-password.txt```. Then you can use command ```ansible-vault --vault-password-file ansible/vault-password.txt encrypt_string``` to encrypt your credentials. The output can be used in the ```ansible/vars/vars.yml``` file, see example in ```content/vars/vars-example.yml file.

You can also put the credentials in plain text, but you should make sure that you don't commit them into any git repository! Files ```ansible/vars/vars.yml``` and ```ansible/vault-password.txt``` are ignored by git in this repository for your safety.


# Provision the lab environment

## Ansible run

Playbook ```provision.yml``` includes other playbooks to create all necessary resources into AWS, and configure each of them. It will use dynamic inventory provided by ```inventory/ec2.py```. That's why you need boto Python modules installed in addition to AWS credentials in ```content/vars/vars.yml```.

```
ansible-playbook --vault-password-file vault-password.txt -i inventory/ec2.py provision.yml
```

_If you don't use Ansible Vault, ignore ```vault-password-file``` parameter_

## Turning off all access to the environment
Because of security reasons when provisoning the environment in advance, or to ensure that all students starts the labs at the same time, you may want to turn off all access to the environment after having provisioned it.
Deny all incoming traffic to the environment by running below playbook:
```
ansible-playbook -i inventory/ec2.py turn_off_access.yml
```

## Turning on all access to the environment
If you have turned off all access to the environment by running the _turn_off_access.yml_ playbook, turn access back to normal by running:
```
ansible-playbook -i inventory/ec2.py turn_on_access.yml
```

## Delete all resources after doing labs

__Beware this might leave something out, do check yourself from your AWS account__

There is a helper playbook, which deletes all resources created for this lab from AWS. But you never know if someone adds something to labs, and forgets to also add it into ```delete_instances.yml``` playbook. If you develop this further, do always remember to include your added resources into ```delete_instances.yml```.

After labs are done, stop billing by running:

```
ansible-playbook --vault-password-file vault-password.txt -i inventory/ec2.py delete_instances.yml
```

_if you don't use vault, ignore ```vault-password-file``` parameter_

Back to [index](../thews.md)