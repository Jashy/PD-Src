#!/usr/bin/python3

import re
import os
import sys
import glob
import gzip
import json

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import openFile as opf

def parse_pnr_qor_rpt(rpt_file):
	f_readlines = opf.readlines_file(rpt_file)
	Dict = {}
	scenarioFlag = ""
	groupFlag = ""
	for line in f_readlines:
		line = line.strip()
		dataTemp = line.split(":")
		matchScenarioLine = re.search("Scenario", line)
		matchTimingGpLine = re.search("Timing Path Group", line)
		matchWNSLine = re.search("Critical Path Slack", line)
		matchTNSLine = re.search("Total Negative Slack", line)
		matchNoVLine = re.search("No. of Violating Paths", line)
		matchHWNSLine = re.search("Worst Hold Violation", line)
		matchHTNSLine = re.search("Total Hold Violation", line)
		matchHNoVLine = re.search("No. of Hold Violations", line)
		if matchScenarioLine:
			headTemp = line.split("'")
			scenarioFlag = headTemp[1].strip()
			if scenarioFlag not in Dict:
				Dict[scenarioFlag] = {}
		elif matchTimingGpLine:
			headTemp = line.split("'")
			if len(headTemp) == 1:
				groupFlag = "no_clock"
			else:
				groupFlag = headTemp[1].strip()
				if groupFlag not in Dict[scenarioFlag]:
					Dict[scenarioFlag][groupFlag] = {}
		elif matchWNSLine:
			Dict[scenarioFlag][groupFlag]["WNS"] = dataTemp[1].strip()
		elif matchTNSLine:
			Dict[scenarioFlag][groupFlag]["TNS"] = dataTemp[1].strip()
		elif matchNoVLine:
			Dict[scenarioFlag][groupFlag]["#Vio"] = dataTemp[1].strip()
		elif matchHWNSLine:
			Dict[scenarioFlag][groupFlag]["Hold WNS"] = dataTemp[1].strip()
		elif matchHTNSLine:
			Dict[scenarioFlag][groupFlag]["Hold TNS"] = dataTemp[1].strip()
		elif matchHNoVLine:
			Dict[scenarioFlag][groupFlag]["Hold #Vio"] = dataTemp[1].strip()
	return Dict

def parse_pt_qor_rpt(rpt_file):
	f_readlines = opf.readlines_file(rpt_file)
	Dict = {}
	for line in f_readlines:
		line = line.strip()
		dataTemp = line.split(":")
		matchTimingGpLine = re.search("Timing Path Group", line)
		matchWNSLine = re.search("Critical Path Slack", line)
		matchTNSLine = re.search("Total Negative Slack", line)
		matchNoVLine = re.search("No. of Violating Paths", line)
		if matchTimingGpLine:
			headTemp = line.split("'")
			groupFlag = headTemp[1].strip()
			if groupFlag not in Dict:
				Dict[groupFlag] = {}
		elif matchWNSLine:
			Dict[groupFlag]["WNS"] = dataTemp[1].strip()
		elif matchTNSLine:
			Dict[groupFlag]["TNS"] = dataTemp[1].strip()
		elif matchNoVLine:
			Dict[groupFlag]["#Vio"] = dataTemp[1].strip()
	return Dict

def get_pnr_stp_qor(stage,corner,group):
	rpt_file = rpt_file = "./rpts/" + stage + "/" + stage + ".report_qor.rpt.gz"
	if os.path.isfile(rpt_file):
		Dict = parse_pnr_qor_rpt(rpt_file)
		read_dict = Dict[corner][group]
		tim_info = read_dict['WNS'].split(".")[0] + "/" + read_dict['TNS'].split(".")[0] + "/" + read_dict['#Vio']
	else:
		tim_info = "N/A"
	return tim_info

def get_pnr_hld_qor(stage,corner,group):
	rpt_file = rpt_file = "./rpts/" + stage + "/" + stage + ".report_qor.rpt.gz"
	if os.path.isfile(rpt_file):
		Dict = parse_pnr_qor_rpt(rpt_file)
		try:
			read_dict = Dict[corner][group]
			tim_info = read_dict['Hold WNS'].split(".")[0] + "/" + read_dict['Hold TNS'].split(".")[0] + "/" + read_dict['Hold #Vio']
		except:
			tim_info = "N/A"
	else:
		tim_info = "N/A"
	return tim_info

def get_pt_corner():
	cfg_file = "./full.json"
	fo = opf.read_file(cfg_file)
	fo_dict = json.loads(fo)
	key1 = "targetCmdCfgDict"
	stp_corners = []
	hld_corners = []
	for key2 in fo_dict[key1]:
		matchStp = re.search(r'^(pt.*_stp_.*)\.cmd',key2)
		matchHld = re.search(r'^(pt.*_hld_.*)\.cmd',key2)
		if matchStp:
			corner = matchStp.group(1)
			stp_corners.append(corner)
		if matchHld:
			corner = matchHld.group(1)
			hld_corners.append(corner)
	return stp_corners,hld_corners

def get_pt_stp_qor(corner,group):
	rpt_file = "./rpts/" + corner + "/qor.max.rpt"
	try:
		Dict = parse_pt_qor_rpt(rpt_file)
		timing_info = Dict[group]["WNS"] + "/" + Dict[group]["TNS"] + "/" + Dict[group]["#Vio"]
	except:
		timing_info = "N/A"
	return timing_info

def get_pt_hld_qor(corner,group):
	rpt_file = "./rpts/" + corner + "/qor.min.rpt"
	try:
		Dict = parse_pt_qor_rpt(rpt_file)
		timing_info = Dict[group]["WNS"] + "/" + Dict[group]["TNS"] + "/" + Dict[group]["#Vio"]
	except:
		timing_info = "N/A"
	return timing_info
