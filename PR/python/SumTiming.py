#!/usr/bin/python3

import re
import os
import sys
import glob
import gzip
import prettytable as pt

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import openFile as opf

def sum_timing(rpt):
	is_timing_report = ""
	is_data_path = ""
	startpoint_cell = ""
	endpoint_cell = ""
	startpoint_clock = ""
	endpoint_clock = ""
	startpoint_latency = ""
	endpoint_latency = ""
	skew = 0
	start_flag = 0
	end_flag = 0
	level_flag = 0
	level = 0
	short_flag = 1
	end_clock_flag = 0
	no_derate_flag = 1
	f_readlines = opf.readlines_file(rpt)
	Dict = {}
	slack_list = []
	for line in f_readlines:
		line = line.strip()
		mHead = re.match("^Report\s+:\s+[tT]iming",line)
		mStart = re.match("Startpoint:\s(\S+)\s\S+\s\S+\s\S+\s\S+\s\S+\s(\S+)\)",line)
		mEnd = re.match("Endpoint:\s(\S+)\s\S+\s\S+\s\S+\s\S+\s\S+\s(\S+)\)",line)
		mSlack = re.match("slack\s+\S+\s+(\S+)",line)
		if mHead:
			is_timing_report = 1
		if is_timing_report and "-path_type full_clock" in line:
			short_flag = 0
		if is_timing_report and "-derate" in line:
			no_derate_flag = 0
		if mStart:
			startpoint_cell = mStart.group(1)
			startpoint_clock = mStart.group(2)
			start_flag = 1
		if mEnd:
			endpoint_cell = mEnd.group(1)
			endpoint_clock = mEnd.group(2)
			end_flag = 1
		if start_flag and startpoint_cell in line and "clocked by" not in line:
			if "CK" in line or "CLK" in line:
				level_flag = 1
				level = 0
				if short_flag:
					reStart = re.match("(\S+)\s+\S+\s+\S+\s+\S+\s+(\S+)",line)
				else:
					reStart = re.match("(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)",line)
				startpoint_pin = reStart.group(1)
				startpoint_latency = round(float(reStart.group(2)),1)
				if startpoint_pin not in Dict:
					Dict[startpoint_pin] = {}
		if level_flag and "(net)" in line:
			level = level + 1
		if end_flag and endpoint_cell in line and "clocked by" not in line:
			if "CK" not in line and "CLK" not in line:
				level_flag = 0
				end_clock_flag = 1
				endpoint_pin = re.match("(\S+)\s+\(",line).group(1)
				if endpoint_pin not in Dict[startpoint_pin]:
					Dict[startpoint_pin][endpoint_pin] = {}
		if end_clock_flag:
			if endpoint_clock in line:
				reClock = re.match("clock\s+\S+\s+\S+\s+\S+\s+(\S+)",line)
				clock_period = round(float(reClock.group(1)),1)
			if endpoint_cell in line:
				if "CK" in line or "CLK" in line:
					if short_flag and no_derate_flag:
						reEnd = re.match("\S+\s+\S+\s+\S+\s+\S+\s+(\S+)",line)
					else:
						reEnd = re.match("\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)",line)
					endpoint_time = round(float(reEnd.group(1)),1)
					endpoint_latency = round(endpoint_time - clock_period,1)
					skew = round(startpoint_latency - endpoint_latency,1)
		if mSlack:
			slack = float(mSlack.group(1))
			slack_list.append(slack)
			Dict[startpoint_pin][endpoint_pin]["slack"] = slack
			Dict[startpoint_pin][endpoint_pin]["level"] = level
			Dict[startpoint_pin][endpoint_pin]["skew"] = skew
			Dict[startpoint_pin][endpoint_pin]["startpoint_clock"] = startpoint_clock
			Dict[startpoint_pin][endpoint_pin]["endpoint_clock"] = endpoint_clock
			Dict[startpoint_pin][endpoint_pin]["startpoint_latency"] = startpoint_latency
			Dict[startpoint_pin][endpoint_pin]["endpoint_latency"] = endpoint_latency
			start_flag = 0
			end_flag = 0
			end_clock_flag = 0
	return Dict,slack_list

def print_sum(Dict):
	new_dict = sorted(Dict.items(),key=lambda d:d[0],reverse=False)
	for key1 in new_dict:
		start_pin = key1[0]
		end_dict = key1[1]
		worst_list = list(end_dict.items())[0]
		worst_end = worst_list[0]
		worst_slack = worst_list[1]
		num = len(end_dict)
		if worst_slack["slack"] <= 0:
			head = str(num) + "\t" + str(start_pin) + " " + str(worst_slack["slack"]) + " (" + str(worst_slack["level"]) + ") " + "(" + worst_slack["startpoint_clock"] + ") " + "(" + str(worst_slack["skew"]) + ")"
			print(head)
			for key2 in end_dict:
				end_pin_dict = end_dict[key2]
				end_pin_slack = " " + str(end_pin_dict["slack"])
				end_pin_level = " (" + str(end_pin_dict["level"]) + ")"
				end_pin_clock = " (" + end_pin_dict["endpoint_clock"] + ":"
				end_pin_latency = str(end_pin_dict["endpoint_latency"]) + ")"
				end_pin_skew = " (" + str(end_pin_dict["skew"]) + ")"
				end_pin = "\t" + key2 + end_pin_slack + end_pin_level + end_pin_clock + end_pin_latency + end_pin_skew
				if end_pin_dict["slack"] <= 0:
					print(end_pin)
			print()

def get_slack(List):
	vio_num = {}
	compare = [0,-10,-20,-30,-40,-50,-60,-70,-80,-90,-100,-110,-120,-130,-140,-150,-160,-170,-180,-190,-200,-300,-400,-500,-1000,-2000,-5000]
	ll = len(compare)
	for i in range(0,ll):
		if i == 0:
			mi = str(compare[i+1]) + "ps"
			ma = "-" + str(compare[i]) + "ps"
			key = mi + " < " + ma
		if i == ll-1:
			mi = str(compare[i]) + "ps"
			key = mi + " > "
		else:
			mi = str(compare[i+1]) + "ps"
			ma = str(compare[i]) + "ps"
			key = mi + " < " + ma
		vio_num[key] = 0
	for j in range(0,ll):
		if j == ll-1:
			key1 = str(compare[j]) + "ps" + " > "
			ma_s = compare[j]
			for L in List:
				if L <= ma_s:
					vio_num[key1] = vio_num[key1] + 1
		else:
			mi_s = compare[j+1]
			ma_s = compare[j]
			key2 = str(mi_s) + "ps" + " < " + str(ma_s) + "ps"
			for L in List:
				if mi_s <= L <= ma_s:
					vio_num[key2] = vio_num[key2] + 1
	return vio_num

def print_slack(Dict):
	tb = pt.PrettyTable()
	tb.field_names = ["violation range","# of violations"]
	for key in Dict:
		row_l = [key,Dict[key]]
		tb.add_row(row_l)
	tb.align = 'l'
	print(tb)

if __name__ == '__main__':
	Dict,List = sum_timing(sys.argv[1])
	slack_dict = get_slack(List)

	print_slack(slack_dict)
	print_sum(Dict)