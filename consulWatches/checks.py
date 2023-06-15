import sys
from influxdb import InfluxDBClient
import json
import requests


checks = sys.stdin.readlines()
checks_list = json.loads(checks[0])


criticalChecks=[(x['Name'],x['ServiceName'],x['Node']) for x in checks_list ]


critical_check = "None"
checks_address = "None"
checks_service = "None"

existing_criticals = []

error = None
client = InfluxDBClient(host="localhost",port=8086,database="checks")
result = None


try:
	result = client.query('select last(existing_criticals) from checks limit 1;')
	error = "connected but facing some error"
except Exception as e:
	error = e.message

if result:
	existing_criticals = [m['last'] for x in result for m in x][0].split(':')
	new_criticals = set([x[0]+'~'+x[1]+'~'+x[2] for x in criticalChecks])
	critical_set = new_criticals.difference(existing_criticals)
#	healthy_set = existing_criticals.difference(new_criticals)
	for checks in critical_set:             
                json_body = [{"measurement":'checks',"fields":{'existing_criticals':':'.join(new_criticals),'critical':checks.split('~')[0],'service':checks.split('~')[1],'address':checks.split('~')[2]}}]
		client.write_points(json_body)
elif "database not found" in error:
	client.create_database('checks')
	for checks in criticalChecks:
		existing_criticals.append('~'.join(checks))             
	        json_body = [{"measurement":'checks',"fields":{'existing_criticals':':'.join(existing_criticals),'critical':checks[0],'service':checks[1],'address':checks[2]}}]
                client.write_points(json_body)

#		existing_nodes.append(node)		
#		json_body = [{"measurement":'nodes',"fields":{'existing_nodes':':'.join(existing_nodes),'new_node':node,'address':node_add_dict[node]}}]

		client.write_points(json_body)
else:
	print error
