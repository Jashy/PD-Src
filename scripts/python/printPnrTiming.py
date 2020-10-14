#!/usr/bin/python3

import os
import re
import sys
import glob
import prettytable as pt

sys.path = sys.path + glob.glob("/home/ex-jia.song@iluvatar.local/pycharm/icpd/tile_status_new")
import getTimingQor
import getMisc

def print_pnr_setup_table():
	tb = pt.PrettyTable()
	tb.field_names = ["Stage-Corner-Setup/Group"]
	stages = getMisc.get_pnr_stages()
	groups = getMisc.get_pnr_groups()
	new_stages = []
	for stage in stages:
		if stage != "icc2_floorplan" and stage != "icc2_powerplan" and stage != "icc2_postfloorplan":
			new_stages.append(stage)
	for stage in new_stages:
		Stp_corners,Hld_corners = getMisc.get_pnr_corners(stage)
		for corner in Stp_corners:
			if stage == "icc2_placeopt":
				line = stage + " :" + corner
			elif stage == "icc2_cts":
				line = stage + "      :" + corner
			elif stage == "icc2_optcts":
				line = stage + "   :" + corner
			elif stage == "icc2_route":
				line = stage + "    :" + corner
			elif stage == "icc2_optroute":
				line = stage + " :" + corner
			else:
				continue
			tb.add_row([line])
	for group in groups:
		g_list = []
		for stage in new_stages:
			Stp_corners,Hld_corners = getMisc.get_pnr_corners(stage)
			for corner in Stp_corners:
				try:
					timing_info = getTimingQor.get_pnr_stp_qor(stage,corner,group)
				except:
					timing_info = "N/A"
				g_list.append(timing_info)
		tb.add_column(group,g_list)
	tb.align = 'l'
	if len(groups) != 0:
		print(tb)

def print_pnr_hold_table():
	stages = getMisc.get_pnr_stages()
	new_stages = []
	for stage in stages:
		if stage != "icc2_floorplan" and stage != "icc2_powerplan" and stage != "icc2_postfloorplan":
			new_stages.append(stage)
	if "icc2_optcts" in new_stages:
		tb = pt.PrettyTable()
		tb.field_names = ["Stage-Corner-Hold/Group"]
		tb.align = 'l'
		stages = getMisc.get_pnr_stages()
		groups = getMisc.get_pnr_groups()
		for stage in new_stages:
			Stp_corners,Hld_corners = getMisc.get_pnr_corners(stage)
			if len(Hld_corners) != 0:
				for corner in Hld_corners:
					if stage == "icc2_optcts":
						line = stage + "   :" + corner
					if stage == "icc2_optroute":
						line = stage + " :" + corner
					tb.add_row([line])
		for group in groups:
			g_list = []
			for stage in new_stages:
				Stp_corners,Hld_corners = getMisc.get_pnr_corners(stage)
				if len(Hld_corners) != 0:
					for corner in Hld_corners:
						try:
							timing_info = getTimingQor.get_pnr_hld_qor(stage,corner,group)
						except:
							timing_info = "N/A"
						g_list.append(timing_info)
			tb.add_column(group,g_list)
		tb.align = 'l'
		if len(groups) != 0:
			print(tb)
