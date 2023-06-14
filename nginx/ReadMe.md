# Cloud_Based_Load_Balancers/nginx

The application used to install NGINX Plus for the topology used in the bebinar is **NGINX Plus with NGINX App Protect - Developer** as shown below
![Azure_NGINX](https://github.com/ISEDemoLab/Cloud_Based_Load_Balancers/blob/main/images/azure_nginx.png)

During the provisioning of the NGINX Server, I chose the **Image** Ubuntu Server 22.04 LTS - x64 Gen2, just due to my familiarity with the platform.

Provisioning this NGINX instance will also create a Network Interface and a Disk configuration.  Then entries it created for me are
```
azure_nginx
azure_nginx945
azure_nginx_OsDisk_1_9ca1be42994643a69aee508af3f39790
```

`azure_nginx` is the name I chose for the NGINX VM, `azure_nginx945` is the Network Interface that was created.  Select the Network Interface and choose `IP configurations`. Here you can add the additional IP addresses to the interface.
![Azure_NGINX_vnic](https://github.com/ISEDemoLab/Cloud_Based_Load_Balancers/blob/main/images/azure_nginx_vnic.png)

Once the IP configurations are added to the Network Interface, ssh to the ubuntu instance (the username is azureuser) and add the additional IP addresses to the interface using the following file
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
            addresses: [192.168.100.106/24, 192.168.102.100/24, 192.168.100.103/24, 192.168.100.104/24]
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

Using the `nginx.conf` file from this repository, the relevant information is added to the `stream` section in `/etc/nginx/nginx.conf` 

Refer to the [NGINX Load Balancer Admin Guide](https://docs.nginx.com/nginx/admin-guide/load-balancer/) for additional options not covered in the `nginx.conf` file.

## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>