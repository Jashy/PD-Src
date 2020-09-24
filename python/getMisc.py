#!/usr/bin/python3

import re
import os
import sys
import glob
import json
import gzip

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import openFile as opf

def parse_cfg(key1,key2,key3):
	cfg_file = "./full.json"
	fo = opf.read_file(cfg_file)
	fo_dict = json.loads(fo)
	try:
		value = fo_dict[key1][key2][key3]
	except:
		value = ""
	return value

def fill_all_stages(stages):
	all_stages = ["icc2_floorplan","icc2_powerplan","icc2_postfloorplan"]
	for stage in stages:
		all_stages.append(stage)
	return all_stages

def get_pnr_stages():
	I2Place = "./pass/icc2_placeopt"
	I2Cts = "./pass/icc2_cts"
	I2OptCts = "./pass/icc2_optcts"
	I2Route = "./pass/icc2_route"
	I2OptRoute = "./pass/icc2_optroute"
	stages = []
	if os.path.isfile(I2Place):
	    stages.append("icc2_placeopt")
	if os.path.isfile(I2Cts):
	    stages.append("icc2_cts")
	if os.path.isfile(I2OptCts):
	    stages.append("icc2_optcts")
	if os.path.isfile(I2Route):
	    stages.append("icc2_route")
	if os.path.isfile(I2OptRoute):
	    stages.append("icc2_optroute")
	return stages

def get_pnr_corners(stage):
	key1 = "targetCmdCfgDict"
	key2 = stage + ".cmd"
	key3 = "scenarios"
	corners = parse_cfg(key1,key2,key3)
	stp_corners = []
	hld_corners = []
	for corner in corners:
		if "stp" in corner:
			stp_corners.append(corner)
		if "hld" in corner:
			hld_corners.append(corner)
	return stp_corners, hld_corners

def get_pnr_groups():
	groups = []
	qor_file = "./rpts/icc2_placeopt/icc2_placeopt.report_qor.rpt.gz"
	if os.path.isfile(qor_file):
		f_readlines = opf.readlines_file(qor_file)
		groupFlag = ""
		for line in f_readlines:
			dataTemp = line.split(":")
			matchTimingGpLine = re.search("Timing Path Group", line)
			if matchTimingGpLine:
				headTemp = line.split("'")
				if len(headTemp) == 1:
					groupFlag = "no_clock"
				else:
					groupFlag = headTemp[1].strip()
					if "in2" not in groupFlag and "2out" not in groupFlag and "default" not in groupFlag and "input" not in groupFlag and "output" not in groupFlag and "tocto" not in groupFlag and "CLK" not in groupFlag:
						groups.append(groupFlag)
	else:
		print("Error! Can't find ./rpts/icc2_placeopt/icc2_placeopt.report_qor.rpt.gz")
	return groups

def get_runtime():
	stages = get_pnr_stages()
	all_stages = fill_all_stages(stages)
	runtimeDict = {}
	total = 0
	for stage in all_stages:
		log_file = "./logs/" + stage + ".log.gz"
		cmd = 'zgrep ' + '"Elapsed time for this session" ' + log_file
		time_info = str(os.popen(cmd).readlines())
		time = re.findall(r'Elapsed\s+time\s+for\s+this\s+session:.*\(\s+(.*)\s+.*\)',time_info)[0]
		total = total + float(time)
		total = round(total,2)
		if stage not in runtimeDict:
			runtimeDict[stage] = time
	runtimeDict["Total"] = total
	return runtimeDict

def get_clock_info():
	clock_dict = {}
	clk_rpt = "./rpts/icc2_cts/icc2_cts.report_clock_qor.all.rpt"
	if os.path.isfile(clk_rpt):
		fo_readlines = opf.readlines_file(clk_rpt)
		for line in fo_readlines:
			line = line.strip()
			flag1 = re.compile(".*Summary Reporting for Corner\s*(\S+)\s*.*")
			flag2 = re.compile("(\S+)\s+M,D\s+(\S+)\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+")
			f1 = flag1.match(line)
			if f1:
				corner = f1.group(1)
				if corner not in clock_dict:
					clock_dict[corner] = {}
			f2 = flag2.match(line)
			if f2:
				clock = f2.group(1)
				sinks = f2.group(2)
				level = f2.group(3)
				repeater = f2.group(4)
				latency = f2.group(5)
				skew = f2.group(6)
				if clock not in clock_dict[corner]:
					clock_dict[corner][clock] = {}
				clock_dict[corner][clock]["clock_name"] = clock
				clock_dict[corner][clock]["sinks"] = sinks
				clock_dict[corner][clock]["level"] = level
				clock_dict[corner][clock]["repeater"] = repeater
				clock_dict[corner][clock]["latency"] = latency
				clock_dict[corner][clock]["skew"] = skew
	else:
		clock_dict = {}
		print("Info: Can't find ",clk_rpt)
	return clock_dict
