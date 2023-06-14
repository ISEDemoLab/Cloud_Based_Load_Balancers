# Cloud_Based_Load_Balancers/ansible

Oracle Cloud Infrastructure offers free compute resources of up to 4 Ampere CPUs, 24GB RAM, and 200GB storage.  This ansible playbook takes advantage of _ALL_ those free resources to install Ubuntu 22.04 with 4 allocated IP addresses on the single vnic.

## Quick Start

Clone this repository:  

```sh
git clone https://github.com/ISEDemoLab/Cloud_Based_Load_Balancers.git
```

Create your Python environment and install Ansible:
> ⚠ Installing Ansible using Linux packages (`sudo apt install ansible`) may result in a much older version of Ansible being installed.  
> 💡 Installing Ansible with Python packages will get you the latest.  
> 💡 If you have any problems installing Python or Ansible, see [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

```sh
pipenv install --python 3.9                # use Python 3.9 or later
pipenv install paramiko                    # ISE SSH/CLI access
pipenv install ansible                     # Ansible packages
pipenv install oci                         # Python packages for OCI
pipenv shell                               # Launch the virtual environment
```

## Requirements
### Create an API Signing Key and default config file for OCI:
[SDK and CLI Configuration File](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm#SDK_and_CLI_Configuration_File)
[Required Keys and OCIDs](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm)

### The following Ansible modules are needed:

- oracle.oci
- ansible.netcommon


## Variables

Edit the project and deployment settings in `vars/main.yaml` to match your environment:

```yaml
project_name: Cloud_Based_Load_Balancers
```

Run an Ansible playbook:  

```sh
ansible-playbook playbook.yaml
```

Once the ubuntu instance is provisioned, ssh to the ubuntu instance (the username is ubuntu) and add the additional IP addresses to the interface using the following file
```
sudo nano /etc/netplan/50-cloud-init.yaml
```

Add the IP addresses as shown, you can specify your DNS servers here, too, under `nameservers`
```
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        enp0s3:
            dhcp4: true
            addresses: [192.168.102.101/24, 192.168.102.105/24, 192.168.102.106/24, 192.168.102.107/24]
            match:
                macaddress: 02:00:17:04:84:8f
            nameservers:
                addresses: [10.1.100.10]
            set-name: enp0s3
```

Restart the system networking with the command
```
sudo netplan apply
```

## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>


