#!/usr/bin/python3

import re
import os
import sys
import glob
import json
import gzip
import shutil

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import openFile as opf
import getMisc as gm

def edit_json(k1,k2,k3,data):
	ini_json = opf.read_file("./full.json")
	new_json = open("./full.json_new","w")
	json_data = json.loads(ini_json)
	json_data[k1][k2][k3] = data
	print(json_data[k1][k2][k3])
	json.dump(json_data,new_json,indent=4)
	new_json.close()
	shutil.move("./full.json","./.full.json.ini")
	shutil.move("./full.json_new","./full.json")

def edit_run():
	ini_json = opf.read_file("./full.json")
	key1 = "targetRunCfgDict"
	key2 = ["icc2_floorplan","icc2_powerplan","icc2_postfloorplan","icc2_placeopt","icc2_cts","icc2_optcts","icc2_route","icc2_optroute","icc2_interactive"]
	json_data = json.loads(ini_json)
	for k2 in key2:
		print(k2)
		edit_json(key1,k2,"CPU","32")
		edit_json(key1,k2,"Queue","pd1t5")
		new_ram = str(int(json_data[key1][k2]["RAM"]) + int(10000))
		edit_json(key1,k2,"RAM",new_ram)

def edit_global():
	key1 = "targetCmdCfgDict"
	key2 = "GLOBAL"
	edit_json(key1,key2,"TWO_PASS_FLOW","1")
	edit_json(key1,key2,"ICC_NUM_CPUS","32")

edit_run()
edit_global()