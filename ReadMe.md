# Cloud_Based_Load_Balancers

This repository is used for the Cloud Based Load Balancers with ISE webinar that was given on June 15, 2023.  The purpose of the webinar was to show RADIUS Load Balancing (udp) with load balancers located in Public Clouds.

![Cloud Based Load Balancers Webinar Cover](https://github.com/ISEDemoLab/Cloud_Based_Load_Balancers/blob/main/images/Cloud_Based_Load_Balancers.png)


Though not all of the scripts in this repository were shown, this is the collection of scripts that I have used in creating this webinar.  To see full details about the load balancers used and how to install them, please visit [RADIUS Load Balancing for ISE](https://cs.co/ise-lb).

The folders in this repository are listed in this table with their functions:
|Folder|Function|
|---|---|
|ansible|Provision an Always Free ubuntu instance in OCI to install Traefik proxy|
|catalyst|Configuration for load balancing on Cisco Catalyst Switches|
|nginx|Configuration file for NGINX Plus|
|prometheus|Configuration files for Prometheus installation on Traefik proxy `OPEN SOURCE`|
|test|Test scripts to send 100 PAP authentications to Load Balancer vips|
|traefik|Static and Dynamic Configuration files for Traefik proxy|

## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>