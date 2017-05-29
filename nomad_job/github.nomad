job "github" {
 

  constraint {
    attribute = "${attr.os.name}"
    value     = "ubuntu"
  }

  update {
    max_parallel = 3
    stagger = "30s"
  }
 
  datacenters = ["dc1"]

  group "github" {
  
    count = 2
#    constraint {
 #     operator  = "distinct_hosts"
  #    value     = "true"
#	       }

    restart {
      attempts = 2
      delay    = "10s"
      interval = "5h"
      mode     = "delay"
            } 
  
  task "application" {

    driver = "docker"
    config {
      image = "shubhashish/helloworld"
      volumes = ["/var/codegladiator/:/codegladiator"]
      port_map {
        app = 5000
               }
		
    command = "python"
      args = ["codegladiator/backend/databaseCommunicator/main.py"]
           }

    logs {
      max_files = 3
      max_file_size = 5
         }

    resources {
      cpu    = 500 # 500 MHz
      memory = 256 # 256MB
      network {
        mbits = 10
	port "http"{}
        port "https"{}
	port "app" {}
              }
              }

    service {
      name = "pythonApplication"
      port = "app"
      tags = ["applicatiion","helloWorld"]
      check {
        type= "http"
        timeout = "30s"
        protocol = "http"
        port = "app"
        interval = "30s"
        name ="HelloWorld"
        path = "/codegladiator/api/hello"
            } 
           } 


}
  task "mongodb" {
    driver = "docker"

    config {
      image = "mongo"
      volumes = ["/etc/mongo.d:/data/configdb","/var/lib/mongodb:/data/db","/var/log/mongodb:/var/log/mongodb"]
      port_map {
        mongo = 27017
        http = 28017
	       }
      args = ["--config","/data/configdb/mongod.conf","--rest"]

	   }

    logs {
      max_files     = 3
      max_file_size = 5
         }

    resources {
      cpu    = 500 # 500 MHz
      memory = 256 # 256MB
      network { 
        mbits = 10
        port "mongo"{}
        port "http"{}
        port "https"{}
              }
              }
    service {
      name = "mongoDB"
      port ="mongo"
      tags=["mongodb"]
      check {
        type= "http"
        timeout = "30s"
       protocol = "http"
        port = "http"
        interval = "30s"
        name ="MongoHTTP"
        path = "/"

            }
            }


  
           }}}
