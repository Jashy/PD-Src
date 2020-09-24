#!/usr/bin/python3

import re,os,sys,gzip

cur_dir = os.getcwd()

def printSplitLine(width):
        singal = "-"
        line = "-"
        for i in range(0,width):
                line = singal + line
        print('{0:<20}'.format(line))

def getInfo():
        cfg_file = "./user.cfg"
        fo = open(cfg_file)
        FE_version = ""
        PD_version = ""
        for line in fo.readlines():
                line = line.strip()
                try:
                        args = line.split('=')
                        arg = args[1]
                        if re.search(r'FEINT_RELEASE_DIR',line):
                                FE_version = arg
                        if re.search(r'PDINT_RELEASE_DIR',line):
                                PD_version = arg
                        if re.search(r'TOP_MODULE ',line):
                                tile_name = re.sub(" ","",arg)
                        if re.search(r'FEINT_RELEASE_STAGE =',line):
                                FE_stage = re.sub(" ","",arg)
                except:
                        continue
        FE_info = FE_version + "/data/" + FE_stage + ".v.gz"
        PD_info = PD_version
        printSplitLine(136)
        print('{0:<12} | {1:<120} |'.format("FE_dir: ",FE_info))
        printSplitLine(136)
        print('{0:<12} | {1:<120} |'.format("PD_dir: ",PD_info))
        printSplitLine(136)
        run_dir = " " + cur_dir
        print('{0:<12} | {1:<120} |'.format("RUN_dir: ",run_dir))
        printSplitLine(136)
        return tile_name

def getSynStage():
        I2Place = "./pass/I2Place"
        I2Cts = "./pass/I2Cts"
        I2OptCts = "./pass/I2OptCts"
        I2Route = "./pass/I2Route"
        I2OptRoute = "./pass/I2OptRoute"
        cur_stage = ""
        stages = []
        if os.path.isfile(I2Place):
                cur_stage = "I2Place"
                stages.append(cur_stage)
        if os.path.isfile(I2Cts):
                cur_stage = "I2Cts"
                stages.append(cur_stage)
        if os.path.isfile(I2OptCts):
                cur_stage = "I2OptCts"
                stages.append(cur_stage)
        if os.path.isfile(I2Route):
                cur_stage = "I2Route"
                stages.append(cur_stage)
        if os.path.isfile(I2OptRoute):
                cur_stage = "I2OptRoute"
                stages.append(cur_stage)
        return stages

def parseQorRpt(fileName):
        f = open(fileName,'r')
        Dict = {}
        scenarioFlag = ""
        groupFlag = ""
        for line in f.readlines():
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
            f.close()
        return Dict

def createDict(group):
        dict_name = group + "_Dict"
        dict_name = {}
        return dict_name

def getSynRpt(rpt,corner,group,group_dict):
        rpt_file = "./SynPnr/rpts/" + rpt + "/" + rpt + ".qor.rpt"
        Dict = parseQorRpt(rpt_file)
        read_dict = group
        read_dict = {}
        read_dict = Dict[corner][group]
        write_dict = group_dict
        flag = rpt + "-" + corner
        write_dict[flag] = read_dict['WNS'].split(".")[0] + "/" + read_dict['TNS'].split(".")[0] + "/" + read_dict['#Vio']
        return write_dict[flag]

def getStaRpt(sta_rpts):
        for sta_rpt in sta_rpts:
                print("STA",sta_rpt,":")
                printSplitLine()
                sta_file = "./STA/" + sta_rpt + "/rpts/qor.max.rpt"
                f = open(sta_file)
                sta_Dict = {}
                groupFlag = ""
                for line in f.readlines():
                        dataTemp = line.split(":")
                        matchTimingGpLine = re.search("Timing Path Group", line)
                        matchWNSLine = re.search("Critical Path Slack", line)
                        matchTNSLine = re.search("Total Negative Slack", line)
                        matchNoVLine = re.search("No. of Violating Paths", line)
                        matchHWNSLine = re.search("Worst Hold Violation", line)
                        matchHTNSLine = re.search("Total Hold Violation", line)
                        matchHNoVLine = re.search("No. of Hold Violations", line)
                        if matchTimingGpLine:
                                headTemp = line.split("'")
                                if len(headTemp) == 1:
                                        groupFlag = "no_clock"
                                else:
                                        groupFlag = headTemp[1].strip()
                                if groupFlag not in sta_Dict:
                                        sta_Dict[groupFlag] = {}
                        elif matchWNSLine:
                                sta_Dict[groupFlag]["WNS"] = dataTemp[1].strip()
                        elif matchTNSLine:
                                sta_Dict[groupFlag]["TNS"] = dataTemp[1].strip()
                        elif matchNoVLine:
                                sta_Dict[groupFlag]["#Vio"] = dataTemp[1].strip()
                        elif matchHWNSLine:
                                sta_Dict[groupFlag]["Hold WNS"] = dataTemp[1].strip()
                        elif matchHTNSLine:
                                sta_Dict[groupFlag]["Hold TNS"] = dataTemp[1].strip()
                        elif matchHNoVLine:
                                sta_Dict[groupFlag]["Hold #Vio"] = dataTemp[1].strip()
                        f.close()
                reg2reg = sta_Dict["reg2reg"]
                reg2cgate = sta_Dict["reg2cgate"]
                from_mac = sta_Dict["from_mac"]
                to_mac = sta_Dict["to_mac"]
                reg2reg_Dict[sta_rpt] = reg2reg["WNS"].split(".")[0] + "/" + reg2reg["TNS"].split(".")[0] + "/" + reg2reg["#Vio"]
                reg2cgate_Dict[sta_rpt] = reg2cgate["WNS"].split(".")[0] + "/" + reg2cgate["TNS"].split(".")[0] + "/" + reg2cgate["#Vio"]
                from_mac_Dict[sta_rpt] = from_mac["WNS"].split(".")[0] + "/" + from_mac["TNS"].split(".")[0] + "/" + from_mac["#Vio"]
                to_mac_Dict[sta_rpt] = to_mac["WNS"].split(".")[0] + "/" + to_mac["TNS"].split(".")[0] + "/" + to_mac["#Vio"]
                print("reg2reg:",reg2reg_Dict[sta_rpt])
                print("reg2cgate:",reg2cgate_Dict[sta_rpt])
                print("from_mac:",from_mac_Dict[sta_rpt])
                print("to_mac:",to_mac_Dict[sta_rpt])
                print("\r")

def getCorners(stage):
        rpt_dir = "./SynPnr/rpts/" + stage + "/detail/"
        corners = os.listdir(rpt_dir)
        return corners

def getGroups(rpt):
        fileName = "./SynPnr/rpts/" + rpt + "/" + rpt + ".qor.rpt"
        f = open(fileName,'r')
        groups = []
        groupFlag = ""
        for line in f.readlines():
                dataTemp = line.split(":")
                matchTimingGpLine = re.search("Timing Path Group", line)
                if matchTimingGpLine:
                        headTemp = line.split("'")
                        if len(headTemp) == 1:
                            groupFlag = "no_clock"
                        else:
                            groupFlag = headTemp[1].strip()
                            #if "in2" not in groupFlag and "2out" not in groupFlag and "default" not in groupFlag and "input" not in groupFlag and "output" not in groupFlag and "tocto" not in groupFlag and "reg2si" not in groupFlag:
                            if "in2" not in groupFlag and "2out" not in groupFlag and "default" not in groupFlag and "input" not in groupFlag and "output" not in groupFlag and "tocto" not in groupFlag and "CLK" not in groupFlag:
                                groups.append(groupFlag)
        f.close()
        return groups

def exportStaStatus(stages):
        stage_head = "I2Place"
        corners = getCorners(stage_head)
        corner = corners[0]
        message = ["Corner",corner]
        head = getGroups(stage_head)
        head.insert(0,"Stage\Group")
        headLen = len(head)
        if headLen == 5:
                printSplitLine(105)
                print('{0[0]:<12} | {0[1]:^89} |'.format(message))
                printSplitLine(105)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} |'.format(head))
                printSplitLine(105)
        elif headLen == 6:
                printSplitLine(128)
                print('{0[0]:<12} | {0[1]:^112} |'.format(message))
                printSplitLine(128)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} |'.format(head))
                printSplitLine(128)
        elif headLen == 7:
                printSplitLine(151)
                print('{0[0]:<12} | {0[1]:^135} |'.format(message))
                printSplitLine(151)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} |'.format(head))
                printSplitLine(151)
        elif headLen == 8:
                printSplitLine(174)
                print('{0[0]:<12} | {0[1]:^158} |'.format(message))
                printSplitLine(174)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} |'.format(head))
                printSplitLine(174)
        elif headLen == 9:
                printSplitLine(197)
                print('{0[0]:<12} | {0[1]:^181} |'.format(message))
                printSplitLine(197)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} |'.format(head))
                printSplitLine(197)
        elif headLen == 10:
                printSplitLine(220)
                print('{0[0]:<12} | {0[1]:^204} |'.format(message))
                printSplitLine(220)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} | {0[9]:^20} |'.format(head))
                printSplitLine(220)
        elif headLen == 11:
                printSplitLine(243)
                print('{0[0]:<12} | {0[1]:^227} |'.format(message))
                printSplitLine(243)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} | {0[9]:^20} | {0[10]:^20} |'.format(head))
                printSplitLine(243)
        elif headLen == 12:
                printSplitLine(266)
                print('{0[0]:<12} | {0[1]:^250} |'.format(message))
                printSplitLine(266)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} | {0[9]:^20} | {0[10]:^20} | {0[11]:^20} |'.format(head))
                printSplitLine(266)
        elif headLen == 13:
                printSplitLine(289)
                print('{0[0]:<12} | {0[1]:^273} |'.format(message))
                printSplitLine(289)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} | {0[9]:^20} | {0[10]:^20} | {0[11]:^20} | {0[12]:^20} |'.format(head))
                printSplitLine(289)
        elif headLen == 14:
                printSplitLine(312)
                print('{0[0]:<12} | {0[1]:^296} |'.format(message))
                printSplitLine(312)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} | {0[9]:^20} | {0[10]:^20} | {0[11]:^20} | {0[12]:^20} | {0[13]:^20} |'.format(head))
                printSplitLine(312)
        elif headLen == 15:
                printSplitLine(335)
                print('{0[0]:<12} | {0[1]:^319} |'.format(message))
                printSplitLine(335)
                print('{0[0]:<12} | {0[1]:^20} | {0[2]:^20} | {0[3]:^20} | {0[4]:^20} | {0[5]:^20} | {0[6]:^20} | {0[7]:^20} | {0[8]:^20} | {0[9]:^20} | {0[10]:^20} | {0[11]:^20} | {0[12]:^20} | {0[13]:^20} | {0[14]:^20} |'.format(head))
                printSplitLine(335)

        for stage in stages:
                #corner = "Func.TT0p75v_tt_0p75v_85c_typical_Stp_Si"
                write_list = [stage]
                groups = getGroups(stage)
                for group in groups:
                        group_dict = createDict(group)
                        read_dict = getSynRpt(stage,corner,group,group_dict)
                        write_list.append(read_dict)
                if headLen == 5:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} |'.format(write_list))
                        printSplitLine(105)
                elif headLen == 6:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} |'.format(write_list))
                        printSplitLine(128)
                elif headLen == 7:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} |'.format(write_list))
                        printSplitLine(151)
                elif headLen == 8:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} |'.format(write_list))
                        printSplitLine(174)
                elif headLen == 9:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} |'.format(write_list))
                        printSplitLine(197)
                elif headLen == 10:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} | {0[9]:>20} |'.format(write_list))
                        printSplitLine(220)
                elif headLen == 11:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} | {0[9]:>20} | {0[10]:>20} |'.format(write_list))
                        printSplitLine(243)
                elif headLen == 12:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} | {0[9]:>20} | {0[10]:>20} | {0[11]:>20} |'.format(write_list))
                        printSplitLine(266)
                elif headLen == 13:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} | {0[9]:>20} | {0[10]:>20} | {0[11]:>20} | {0[12]:>20} |'.format(write_list))
                        printSplitLine(289)
                elif headLen == 14:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} | {0[9]:>20} | {0[10]:>20} | {0[11]:>20} | {0[12]:>20} | {0[13]:>20} |'.format(write_list))
                        printSplitLine(312)
                elif headLen == 15:
                        print('{0[0]:<12} | {0[1]:>20} | {0[2]:>20} | {0[3]:>20} | {0[4]:>20} | {0[5]:>20} | {0[6]:>20} | {0[7]:>20} | {0[8]:>20} | {0[9]:>20} | {0[10]:>20} | {0[11]:>20} | {0[12]:>20} | {0[13]:>20} | {0[14]:>20} |'.format(write_list))
                        printSplitLine(335)

def getInstCount(stages):
        InstCountDict = {}
        try:
                I2Floorplan = "./SynPnr/rpts/I2Floorplan/I2Floorplan.qor.rpt"
                fo = open(I2Floorplan)
                for line in fo.readlines():
                        if "Leaf Cell Count" in line:
                                line = line.strip()
                                temp = line.split(":")
                                num = temp[-1]
                                num = re.sub(" ","",num)
                                if "I2Floorplan" not in InstCountDict:
                                        InstCountDict["I2Floorplan"] = num
                fo.close()
                try:
                        for stage in stages:
                                qor_rpt = "./SynPnr/rpts/" + stage + "/" + stage + ".qor.rpt"
                                fo = open(qor_rpt)
                                for line in fo.readlines():
                                        if "Leaf Cell Count" in line:
                                                line = line.strip()
                                                temp = line.split(":")
                                                num = re.sub(" ","",temp[-1])
                                                if stage not in InstCountDict:
                                                        InstCountDict[stage] = num
                                fo.close()
                except:
                        print("PnR not finish yet!")
        except:
                print("Floorplan not ready!")
        return InstCountDict

def getUtl(stages):
        UtilizationDict = {}
        try:
                I2Floorplan = "./SynPnr/rpts/I2Floorplan/I2Floorplan.utilization.rpt"
                fo = open(I2Floorplan)
                for line in fo.readlines():
                        if "Utilization Ratio" in line:
                                line = line.strip()
                                temp = line.split(':')
                                utilization = re.sub("\t","",temp[-1])
                                if "I2Floorplan" not in UtilizationDict:
                                        UtilizationDict["I2Floorplan"] = utilization
                fo.close()
                try:
                        for stage in stages:
                                utl_rpt = "./SynPnr/rpts/" + stage + "/" + stage + ".utilization.rpt"
                                fo = open(utl_rpt)
                                for line in fo.readlines():
                                        if "Utilization Ratio" in line:
                                                line = line.strip()
                                                temp = line.split(':')
                                                utilization = re.sub("\t","",temp[-1])
                                                if stage not in UtilizationDict:
                                                        UtilizationDict[stage] = utilization
                                fo.close()
                except:
                        pass
        except:
                pass
        return UtilizationDict

def getCongestion(stages):
        for stage in stages:
                con_rpt = "./SynPnr/rpts/" + stage + "/" + stage + ".congestion.rpt"
                if os.path.exists(con_rpt):
                        cmd = "grep -C2 \"Both\" " + con_rpt
                        printSplitLine(62)
                        print(stages[0],"Congestion Report: ")
                        printSplitLine(62)
                        os.system(cmd)
                        printSplitLine(62)
                else:
                        print("I2Place not ready!")

def exportPhyStatus(stages,InstCountDict,UtilizationDict):
        printSplitLine(62)
        head = ["Stage","Inst Count","Utilization"]
        print('{0[0]:<12} | {0[1]:^22} | {0[2]:^21} |'.format(head))
        printSplitLine(49)
        fp_mes = ["I2Floorplan",InstCountDict["I2Floorplan"],UtilizationDict["I2Floorplan"]]
        print('{0[0]:<12} | {0[1]:^22} | {0[2]:^21} |'.format(fp_mes))
        printSplitLine(62)
        for stage in stages:
                inst_count = InstCountDict[stage]
                utilization = UtilizationDict[stage]
                message = [stage,inst_count,utilization]
                print('{0[0]:<12} | {0[1]:^22} | {0[2]:^21} |'.format(message))
                printSplitLine(62)

def getSize(tile):
        def_file = "SynPnr/data/" + tile + ".GetDef.def.gz"
        with gzip.open(def_file,'r') as fo:
                for line in fo.readlines():
                        line = str(line)
                        if "DIEAREA" in line:
                                points = line.split(') (')
                                for point in points:
                                        if "-" not in point:
                                                point = point.strip().split(' ')
                                                x = str(int(point[0]) / 1000.00)
                                                y = str(int(point[1]) / 1000.00)
                                                size = " " + x + " x " + y
                                                print('{0:<12} | {1:<120} |'.format("SIZE: ",size))
                                                printSplitLine(136)

if __name__ == '__main__':
        tile = getInfo()
        getSize(tile)
        stages = getSynStage()
        try:
                exportStaStatus(stages)
        except:
                #print("PnR not finished yet!")
                pass
        try:
                InstCountDict = getInstCount(stages)
                UtilizationDict = getUtl(stages)
                exportPhyStatus(stages,InstCountDict,UtilizationDict)
        except:
                #print("Floorplan not ready!")
                pass
        try:
                getCongestion(["I2Place"])
        except:
                print("I2Place not finished yet!")