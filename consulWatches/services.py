import sys
from influxdb import InfluxDBClient
import json
import requests


services = sys.stdin.readlines()
services_list = json.loads(services[0]).keys()

services = ""


new = "None"
existing_services = []
error = None
client = InfluxDBClient(host="localhost",port=8086,database="services")
result = None
try:
	result = client.query('select last(existing_services) from services limit 1;')
except Exception as e:
	
	error = e.message
if result:
	existing_services = [m['last'] for x in result for m in x][0].split(':')
	new_services = set(services_list)
	diff_set = new_services.difference(existing_services)
	for service in diff_set:
		existing_services.append(service)             
                json_body = [{"measurement":'services',"fields":{'existing_services':':'.join(existing_services),'new_service':service}}]
		client.write_points(json_body)
elif "database not found" in error:
	client.create_database('services')
	for service in services_list:
		existing_services.append(service)
		json_body = [{"measurement":'services',"fields":{'existing_services':':'.join(existing_services),'new_service':service}}]

		client.write_points(json_body)
else:
	print error
