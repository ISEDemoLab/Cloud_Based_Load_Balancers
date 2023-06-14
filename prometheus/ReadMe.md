# Cloud_Based_Load_Balancers/prometheus

## Install Prometheus
These instrudtions are for installation on Debian-based linux (I'm using Ubuntu 22.04)

### Prepare yout Linux host
Start off by updating the package lists as follows:
```
sudo apt update
```

Once the package index is refreshed and up to date, head over to the next step.

Prometheus installation files come in precompiled binaries in compressed tarball or zipped files. To download Prometheus, head over to the [official download page](https://github.com/prometheus/prometheus/releases). There, you can find the latest release specific to your hardware.

But first, we need to create the configuration and data directories for Prometheus.

To create the configuration directory, run the command:
```
sudo mkdir -p /etc/prometheus
```

For the data directory, execute:
```
sudo mkdir -p /var/lib/prometheus
```

Once the directories are created, grab the compressed installation file:
```
wget https://github.com/prometheus/prometheus/releases/download/v2.38.0/prometheus-2.38.0.linux-arm64.tar.gz
```

Once downloaded, extract the tarball file.
```
tar -xvf prometheus-2.38.0.linux-arm64.tar.gz
```

Then navigate to the Prometheus folder.
```
cd prometheus-2.31.3.linux-amd64
```

### Installation
Once in the directory move the  prometheus and promtool binary files to `usr/local/bin/` folder.
```
sudo mv prometheus promtool /usr/local/bin/
```

Additionally, move console files in console directory and library files in the `console_libraries`  directory to `/etc/prometheus/` directory.
```
sudo mv consoles/ console_libraries/ /etc/prometheus/
```

Also, ensure to move the prometheus.yml template configuration file to the  `/etc/prometheus/` directory.
```
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
```

At this point, Prometheus has been successfully installed. To check the version of Prometheus installed, run the command:

```
prometheus --version
```

Output:
```
prometheus, version 2.38.0 (branch: HEAD, revision: 818d6e60888b2a3ea363aee8a9828c7bafd73699)
  build user:       root@e6b781f65453
  build date:       20220816-13:29:14
  go version:       go1.18.5
  platform:         linux/arm64
```

To check the version of Promtool installed, run the command:
```
promtool --version
```

Output:
```
promtool, version 2.38.0 (branch: HEAD, revision: 818d6e60888b2a3ea363aee8a9828c7bafd73699)
  build user:       root@e6b781f65453
  build date:       20220816-13:29:14
  go version:       go1.18.5
  platform:         linux/arm64
```

If your output resembles what I have, then you are on the right track. In the next step, we will create a system group and user.

### Configuration
It's essential that we create a Prometheus group and user before proceeding to the next step which involves creating a system file for Prometheus.

To  create a prometheus group execute the command:
```
sudo groupadd --system prometheus
```

Thereafter, Create prometheus user and assign it to the just-created prometheus group.
```
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
```

Next, configure the directory ownership and permissions as follows.
```
sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
sudo chmod -R 775 /etc/prometheus/ /var/lib/prometheus/
```

The only part remaining is to make Prometheus a systemd service so that we can easily manage its running status.
Create a systemd file for Prometheus
Using your favorite text editor, create a systemd service file:
```
sudo nano /etc/systemd/system/prometheus.service
```

Paste the following lines of code.
```/etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Restart=always
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
```

Save the changes and exit the systemd file.
Then proceed and start the Prometheus service.
```
sudo systemctl start prometheus
```

Enable the Prometheus service to run at startup. Therefore invoke the command:
```
sudo systemctl enable prometheus
```

Then confirm the status of the Prometheus service.
```
sudo systemctl status prometheus
```


### Access Prometheus
Finally, to access Prometheus, launch your browser and visit your server's IP address followed by port 9090.

If you have a UFW firewall running, open the 9090 port:
```
sudo ufw allow 9090/tcp
sudo ufw reload
```
Back to your browser. Head over to the address indicated.
http://server-ip:9090


## Configure Prometheus

> 💡You must Configure Traefik for Prometheus to set the port used below

Once you have Traefik configured to output to Prometheus, edit the file below to add Traefik to the configuration.

```
sudo nano /etc/prometheus/prometheus.yml
```

The `job_name` and `targets` need to be configured for your Traefik instance.
```/etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
alerting:
  alertmanagers:
  - follow_redirects: true
    enable_http2: true
    scheme: http
    timeout: 10s
    api_version: v2
    static_configs:
    - targets: []
scrape_configs:
- job_name: Traefik
  honor_timestamps: true
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  follow_redirects: true
  enable_http2: true
  static_configs:
  - targets:
    - traefik.securitydemo.net:8082
```

## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>