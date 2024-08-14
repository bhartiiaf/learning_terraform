#!/bin/bash
# Install Prometheus
sudo useradd --no-create-home prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo yum install wget -y
wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
tar xvfz prometheus-2.46.0.linux-amd64.tar.gz
sudo cp prometheus-2.46.0.linux-amd64/prometheus /usr/local/bin
sudo cp prometheus-2.46.0.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-2.46.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.46.0.linux-amd64/console_libraries /etc/prometheus
sudo cp prometheus-2.46.0.linux-amd64/promtool /usr/local/bin/
sudo cp  prometheus-2.46.0.linux-amd64/prometheus.yml /etc/prometheus
#rm -rf prometheus-2.46.0.linux-amd64.tar.gz prometheus-2.46.0.linux-amd64

sudo tee -a /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target
EOF

sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Install Grafana
sudo yum install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-10.0.3-1.x86_64.rpm
sudo systemctl enable --now grafana-server.service
# Configuring Grafana Dashboard
wget https://grafana.com/api/dashboards/5204/revisions/1/download
grafana-cli dashboard import 5204_rev1.json


