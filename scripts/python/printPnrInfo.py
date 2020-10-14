#!/usr/bin/python3

import os
import re
import sys
import glob
import prettytable as pt

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status")
import getMisc as gm
import getPhyInfo as gpi

def print_basic_table():
	tb = pt.PrettyTable()
	tb.field_names = ["Key Word","Value"]
	size = gpi.get_size()
	run_dir = os.getcwd()
	key1 = "targetCmdCfgDict"
	key2 = "GLOBAL"
	top_module = gm.parse_cfg(key1,key2,"TOP_MODULE")
	fe_dir = gm.parse_cfg(key1,key2,"FEINT_RELEASE_DIR")
	fe_stage = gm.parse_cfg(key1,key2,"FEINT_RELEASE_STAGE")
	fe_netlist = fe_dir + "/" + top_module + "/data/" + fe_stage + ".v.gz"
	fe_sdc = fe_dir + "/" + top_module + "/data/" + fe_stage + ".sdc.gz"
	pd_dir = gm.parse_cfg(key1,key2,"PDINT_RELEASE_DIR")
	##
	row0 = ["TILE",top_module]
	row1 =  ["SIZE",size]
	row2 =  ["NETLIST",fe_netlist]
	row3 =  ["SDC",fe_sdc]
	row4 =  ["PDINT",pd_dir]
	row5 =  ["DIR",run_dir]
	tb.add_row(row0)
	tb.add_row(row1)
	tb.add_row(row2)
	tb.add_row(row3)
	tb.add_row(row4)
	tb.add_row(row5)
	tb.align = 'l'
	print(tb)
	

def print_phy_table():
	tb = pt.PrettyTable()
	tb.field_names = ["Stage","Inst Count","Utilization","Run Time"]
	stages = gm.get_pnr_stages()
	inst_count_dict = gpi.get_inst_count(stages)
	utilization_dict = gpi.get_utilization(stages)
	runtime_dict = gm.get_runtime()
	for stage in stages:
		try:
			s_list = [stage]
			s_list.append(inst_count_dict[stage])
			s_list.append(utilization_dict[stage])
			s_list.append(runtime_dict[stage])
			tb.add_row(s_list)
		except:
			continue
	tb.add_row(["Total","N/A","N/A",runtime_dict["Total"]])
	tb.align = 'l'
	print(tb)
	#gpi.get_congestion()

def print_clock_table():
	stages = gm.get_pnr_stages()
	if "icc2_cts" in stages:
		tb = pt.PrettyTable()
		tb.field_names = ["Corner","Clock","Latency","Skew","Level","Sink","Repeater"]
		clock_dict = gm.get_clock_info()
		for key1 in clock_dict:
			corner = key1
			for key2 in clock_dict[key1]:
				clock = key2
				c_list = [corner,clock]
				sinks = clock_dict[corner][clock]["sinks"]
				repeater = clock_dict[corner][clock]["repeater"]
				latency = clock_dict[corner][clock]["latency"]
				skew = clock_dict[corner][clock]["skew"]
				level = clock_dict[corner][clock]["level"]
				c_list = [corner,clock,latency,skew,level,sinks,repeater]
				if int(repeater) >= 0:
					tb.add_row(c_list)
		tb.align = 'l'
		print(tb)
