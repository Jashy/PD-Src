#!/usr/bin/python3

import re
import os
import sys
import glob
import gzip

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

def get_pnr_stp_qor(stage,corner,group):
	rpt_file = rpt_file = "./rpts/" + stage + "/" + stage + ".report_qor.rpt.gz"
	if os.path.isfile(rpt_file):
		Dict = parse_pnr_qor_rpt(rpt_file)
		read_dict = Dict[corner][group]
		tim_info = read_dict['WNS'].split(".")[0] + "/" + read_dict['TNS'].split(".")[0] + "/" + read_dict['#Vio']
	else:
		tim_info = "N/A"
		print("Error! Can't find: " , rpt_file)
	return tim_info

def get_pnr_hld_qor(stage,corner,group):
	rpt_file = rpt_file = "./rpts/" + stage + "/" + stage + ".report_qor.rpt.gz"
	if os.path.isfile(rpt_file):
		Dict = parse_pnr_qor_rpt(rpt_file)
		read_dict = Dict[corner][group]
		tim_info = read_dict['Hold WNS'].split(".")[0] + "/" + read_dict['Hold TNS'].split(".")[0] + "/" + read_dict['Hold #Vio']
	else:
		tim_info = "N/A"
		print("Error! Can't find: " , rpt_file)
	return tim_info
