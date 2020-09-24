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
	fe = gm.parse_cfg(key1,key2,"FEINT_RELEASE_DIR")
	fe_stage = gm.parse_cfg(key1,key2,"FEINT_RELEASE_STAGE")
	##
	row0 = ["TILE SIZE",size]
	row1 = ["FEINT RELEASE DIR",fe]
	row2 = ["FE STAGE",fe_stage]
	row3 = ["RUN DIR",run_dir]
	tb.add_row(row0)
	tb.add_row(row1)
	tb.add_row(row2)
	tb.add_row(row3)
	tb.align = 'l'
	print(tb)
	

def print_phy_table():
	tb = pt.PrettyTable()
	tb.field_names = ["Stage","Inst Count","Util","Runtime"]
	stages = gm.fill_all_stages(gm.get_pnr_stages())
	inst_count_dict = gpi.get_inst_count(stages)
	utilization_dict = gpi.get_utilization(stages)
	runtime_dict = gm.get_runtime()
	for stage in stages:
		s_list = [stage]
		s_list.append(inst_count_dict[stage])
		s_list.append(utilization_dict[stage])
		s_list.append(runtime_dict[stage])
		tb.add_row(s_list)
	tb.add_row(["Total","N/A","N/A",runtime_dict["Total"]])
	tb.align = 'l'
	print(tb)
	#gpi.get_congestion()

def print_clock_table():
	stages = gm.fill_all_stages(gm.get_pnr_stages())
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
				tb.add_row(c_list)
		tb.align = 'l'
		print(tb)
