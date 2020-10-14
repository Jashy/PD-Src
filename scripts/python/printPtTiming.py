#!/usr/bin/python3

import os
import re
import sys
import glob
import prettytable as pt

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import getTimingQor
import getMisc

def print_pt_setup_table():
	all_pass = " ".join(os.listdir("./pass/"))
	if "pt_func" in all_pass:
		tb = pt.PrettyTable()
		tb.field_names = ["Pt-Corner-Setup/Group"]
		stp_corners,hld_corners = getTimingQor.get_pt_corner()
		groups = getMisc.get_pnr_groups()
		for corner in stp_corners:
			line_head = corner
			tb.add_row([line_head])
		for group in groups:
			g_list = []
			for corner in stp_corners:
				try:
					timing_info = getTimingQor.get_pt_stp_qor(corner,group)
				except:
					timing_info = "N/A"
				g_list.append(timing_info)
			tb.add_column(group,g_list)
		tb.align = 'l'
		print(tb)

def print_pt_hold_table():
	all_pass = " ".join(os.listdir("./pass/"))
	if "pt_func" in all_pass:
		tb = pt.PrettyTable()
		tb.field_names = ["Pt-Corner-Hold/Group"]
		stp_corners,hld_corners = getTimingQor.get_pt_corner()
		groups = getMisc.get_pnr_groups()
		for corner in hld_corners:
			line_head = corner
			tb.add_row([line_head])
		for group in groups:
			g_list = []
			for corner in hld_corners:
				try:
					timing_info = getTimingQor.get_pt_hld_qor(corner,group)
				except:
					timing_info = "N/A"
				g_list.append(timing_info)
			tb.add_column(group,g_list)
		tb.align = 'l'
		print(tb)