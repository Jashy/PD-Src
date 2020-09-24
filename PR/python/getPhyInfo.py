#!/usr/bin/python3

import re
import os
import gzip
import sys
import glob

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import getMisc as gm
import openFile as opf

def get_inst_count(stages):
	all_stages = gm.fill_all_stages(stages)
	InstCountDict = {}
	for stage in all_stages:
		qor_rpt = "./rpts/" + stage + "/" + stage + ".report_qor.rpt.gz"
		if os.path.isfile(qor_rpt):
			fo_readlines = opf.readlines_file(qor_rpt)
			for line in fo_readlines:
				if "Leaf Cell Count" in line:
					line = line.strip()
					temp = line.split(":")
					num = re.sub(" ", "", temp[-1])
					if stage not in InstCountDict:
						InstCountDict[stage] = num
		else:
			InstCountDict[stage] = "N/A"
	return InstCountDict

def get_utilization(stages):
	stages = gm.fill_all_stages(stages)
	UtilizationDict = {}
	for stage in stages:
		utl_rpt = "./rpts/" + stage + "/" + stage + ".report_utilization.rpt.gz"
		if os.path.isfile(utl_rpt):
			fo_readlines = opf.readlines_file(utl_rpt)
			for line in fo_readlines:
				if "Utilization Ratio" in line:
					line = line.strip()
					temp = line.split(':')
					utilization = re.sub("\t", "", temp[-1])
					if stage not in UtilizationDict:
						UtilizationDict[stage] = utilization
		else:
			UtilizationDict[stage] = "N/A"
	return UtilizationDict

def get_congestion():
	con_rpt = "./rpts/icc2_placeopt/icc2_placeopt.report_congestion.rpt.gz"
	if os.path.exists(con_rpt):
		cmd = "zgrep -C2 \"Both\" " + con_rpt
		print("icc2_placeopt Congestion Report: ")
		os.system(cmd)
	else:
		print("Info: Can't find ", con_rpt)

def get_size():
	tile = gm.parse_cfg("targetCmdCfgDict","GLOBAL","TOP_MODULE")
	def_file = "data/py_get_pnr_inputs/" + tile + ".GetDef.def.gz"
	if os.path.isfile(def_file):
		cmd = 'zgrep ' + '"DIEAREA" ' + def_file
		size_info = str(os.popen(cmd).readlines()[0])
		points = size_info.strip().split(') (')
		for point in points:
			if "-" not in point:
				point = point.strip().split(' ')
				x = str(int(point[0]) / 1000.00)
				y = str(int(point[1]) / 1000.00)
				size = " " + x + " x " + y
	else:
		size = "N/A"
	return size