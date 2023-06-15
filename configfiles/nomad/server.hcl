log_level = "DEBUG"
#region = "ec2"
# Setup data dir
data_dir = "/tmp/server"

bind_addr ="0.0.0.0"

# Enable the server
server {
    enabled = true
#    encrypt = "dprJIHoCDTz41vW9nXZteA=="
    # Self-elect, should be 3 or 5 for production
   bootstrap_expect = 2
  # retry_join = ["172.31.26.98"]
#EnableSingleNode= true
}
#tls {
 # http = true
#  rpc  = true

#  ca_file   = "/home/ubuntu/ssl/ca.pem"
 # cert_file = "/home/ubuntu/ssl/nomad.pem"
 # key_file  = "/home/ubuntu/ssl/nomad-key.pem"
#}
advertise {
  # Defaults to the node's hostname. If the hostname resolves to a loopback
  # address you must manually configure advertise addresses.
  http = "172.31.18.130"
  rpc  = "172.31.18.130"
  serf = "172.31.18.130"
 # non-default ports may be specified
}


