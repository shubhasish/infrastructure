import sys
from influxdb import InfluxDBClient
import json
import requests


nodes = sys.stdin.readlines()
nodes_list = json.loads(nodes[0])

nodes = ""
node_add_dict={}
for node in nodes_list:
	
	node_add_dict[node['Node']] = node['Address'] 


new = "None"
new_address = "None"
existing_nodes = []
error = None
client = InfluxDBClient(host="localhost",port=8086,database="nodes")
result = None
try:
	result = client.query('select last(existing_nodes) from nodes limit 1;')
except Exception as e:
	
	error = e.message
if result:
	existing_nodes = [m['last'] for x in result for m in x][0].split(':')
	new_nodes = set(node_add_dict.keys())
	diff_set = new_nodes.difference(existing_nodes)
	for node in diff_set:
		existing_nodes.append(node)             
                json_body = [{"measurement":'nodes',"fields":{'existing_nodes':':'.join(existing_nodes),'new_node':node,'address':node_add_dict[node]}}]
		client.write_points(json_body)
elif "database not found" in error:
	client.create_database('nodes')
	for node in node_add_dict.keys():
		existing_nodes.append(node)		
		json_body = [{"measurement":'nodes',"fields":{'existing_nodes':':'.join(existing_nodes),'new_node':node,'address':node_add_dict[node]}}]

		client.write_points(json_body)
else:
	print error
