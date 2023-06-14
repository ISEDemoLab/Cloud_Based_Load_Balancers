# Cloud_Based_Load_Balancers/traefik

## Install Traefik

I installed Traefik in the shell, not in docker or any other container, this installation option seems to be abnormal as I could only find instructions for installation in a Docker container.  I'll provide the full installation process I used.

Create a directory for Traefik and cd into it
```
mkdir traefik && cd traefik
```

Download the latest build from https://github.com/traefik/traefik/releases
```
wget https://github.com/traefik/traefik/releases/download/v2.10.1/traefik_v2.10.1_linux_arm64.tar.gz
```

Unzip the archive
```
tar -zxvf traefik_v2.10.1_linux_arm64.tar.gz
```

### Configure Traefik

Create the static configuration file
```traefik.yaml
# Static configuration
##############################################################################
# An `entryPoint` tells traefik to listen on specific ports.
# EntryPoints with an address formatted as :80 will use the system IP address.
# To use a specific alternate IP address inster the IP address before the port
# as shown below.  UDP ports _MUST_ be labeled as such, otherwise the 
# default (tcp) will be used. For options and variables, visit
# https://doc.traefik.io/traefik/routing/entrypoints/
##############################################################################
entryPoints:
  unsecure:
    address: :80
  secure:
    address: :443
  metrics:
    address: :8082
  auth1:
    address: "192.168.102.105:1812/udp"
  auth2:
    address: "192.168.102.106:1812/udp"
  auth3:
    address: "192.168.102.107:1812/udp"
  acct1:
    address: "192.168.102.105:1813/udp"
  acct2:
    address: "192.168.102.106:1813/udp"
  acct3:
    address: "192.168.102.107:1813/udp"
  tacacs:
    address: "192.168.102.105:49"
  web:
    address: "192.168.102.106:8443"

##############################################################################
# The `providers` section lists the services that exist on your infrastructure
# In this example, I use a File Provider that will enable a dynamic 
# configuration to be used.  The `watch: true` flag will monitor the file
# (or folder) for changes and immediately implement them
# For options and variables, visit
# https://doc.traefik.io/traefik/routing/overview/
##############################################################################
providers:
  file:
    # filename: "config/radius.yaml"
    #######################################################################
    # To use a single file instead of a directory, un-comment the line
    # above and add the path to your dynamic configuration files 
    # (comment out or delete the `directory` entry below).
    #######################################################################
    directory: config
    watch: true

##############################################################################
# To enable the Traefik dashboard add this section
# For options and variables, visit
# https://doc.traefik.io/traefik/operations/dashboard/
##############################################################################
api:
  dashboard: true
  insecure: true
```

Create the dynamic configuration file.  The dynamic configurations have different requirements based upon the traffic for which they are configured.  Samples of each are in the `config` folder.

### Run Traefik
from the `traefik/` folder run
```
sudo ./traefik
```

You should receive an `INFO` message as shown below
```
INFO[0000] Configuration loaded from file: /home/ubuntu/traefik/traefik.yaml
```


## Configure Traefik for Prometheus

Add the following to your static configuration (`traefik.yaml`)
```
##############################################################################
# To output metrics to Prometheus add the following section
# For options and variables, visit
# https://doc.traefik.io/traefik/observability/metrics/prometheus/
##############################################################################
metrics:
  prometheus:
    addEntryPointsLabels: true
    addRoutersLabels: true
    addServicesLabels: true
    headerLabels:
      label: headerKey
    entryPoint: metrics
```

Save and restart Traefik

### Add Traefik as a Data source for Infrastructure Monitoring in ISE

> 💡 This step can only be completed once Prometheus is installed and configured.

Prometheus is used as a Data source for Grafana which is embedded into ISE versions 3.2 and newer.  In this step, I'll walk you through adding a Data source and new dashboard to monitor your Traefik Load Balancer within ISE.

Log in to the ISE Web GUI and navigate to **Operations > System 360 > Monitoring**.  Click the ⚙️ icon and choose **Data sources**.  Select **Add data source** and enter the information from your Prometheus installation on your Traefik server.  The minimum values needed are **Name** and **URL**.

### Add a new dashboard for Traefik in ISE
While in Infrastructure Monitoring, select the ➕ to add a **New dashboard**.  Choose whether to **Add a new panel**, **Add a new row**, or **Add a panel from the panel library**.  For the webinar I chose **Add a new panel** for all my visualizations.

From the **Data source** dropdown (1), change from **Prometheus** to what you named your Traefik Data source, I named mine **Traefik LB** so I chose that.  You can also choose **Mixed** to add metrics from multiple data sources.

Just below the Data Source you'll see another dropbown for **Metrics browser** (2).  Select the metric you'd like to view and then choose the labels to search (2a).  When you have this, select the **Use query** button.

Then use the Visualizations dropdown (3) to select how the data is presented.

Finally, **Save** to save the visualization and **Apply** (4) to exit edit mode and return to the dashboard

![Grafana Config](https://github.com/ISEDemoLab/Cloud_Based_Load_Balancers/blob/main/images/grafana_ise.png)

## Configure Traefik for ElasticSearch

ElasticSearch is used in the ELK Stack (ElasticSearch, LogStash, Kibana) to create visualizations based on log information.  The configuration below outputs the logs from Traefik into ElasticSearch Native JSON format.

Add the following to your static configuration (`traefik.yaml`)
```
##############################################################################
# To configure access logging add this section
# This will allow you to use LogStash or ElasticSearch to parse the logs
# For options and variables, visit
# https://doc.traefik.io/traefik/observability/access-logs/
##############################################################################
accessLog:
  filePath: "/logs/access.log"
  bufferingSize: 100
  format: json
  filters:
    statusCodes:
      - "200"
      - "300-302"
    retryAttempts: true
    minDuration: "10ms"
```

Save and restart Traefik

Unfortunately, Log Analytics in ISE (the embedded ELK stack) does not allow for additional data sources like Infrastructure Monitoring does.


## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>