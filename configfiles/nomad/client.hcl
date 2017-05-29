#onncrease log verbosity
log_level = "DEBUG"
#region = "ec2"
datacenter ="dc1"
# Setup data dir
data_dir = "/tmp/client"
bind_addr = "0.0.0.0"

# Enable the client
client {
    enabled = true
    options = {
docker.cleanup.image = false
}

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["172.31.18.130:4647","172.31.26.98:4647"]
}

#tls{	
 # http = true
#  rpc  = true

 # ca_file   = "/home/ubuntu/ssl/ca.pem"
 # cert_file = "/home/ubuntu/ssl/nomad.pem"
 # key_file  = "/home/ubuntu/ssl/nomad-key.pem"

 # verify_server_hostname = true
#}
# Modify our port to avoid a collision with server1
ports {
    http = 5656
}
telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  statsd_address = "172.31.18.90:8125"
}

