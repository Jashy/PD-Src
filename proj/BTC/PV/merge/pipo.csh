#!/bin/csh -f

#source ~/cal_2013.lic
source  /filer/home/jasons/.cshrc	
source  /filer/home/jasons/virtuso.lic

### SETTING SECTION (NEED TO UPDATE) ###########################################

set ready	= ../../Ready/gds.ready 
set gds		= ../../OUTPUT/LKB11.gds.gz
set gds_top	= LKB11;#primary cell
set mydate	= `date +%m-%d`


### SETTING SECTION (DEFAULT VALUES) ###########################################

set IP_merge	= ${gds_top}_IP_merge.gds
set IP_merge_top	= ${gds_top}
set libname     = ${gds_top}    ; # OPUS LIBRARY

set Guard_top	= guardring
set guardlib    = guardring_0826 ;

set final	= ${gds_top}.gds	; # FINAL  GDS
set final_top	= ${gds_top}	; # FINAL PRIMARY CELL NAME

set opus_tech	= "/proj/BTC/LIB_NEW/TechFile/FoundryTechfile/PDK/SEC_CDS/oa/cmos14lpp_tech_8M_3Mx_4Cx_1Gx_LB/cmos14lpp_tech_8M_3Mx_4Cx_1Gx_LB.tf"
set layer_map	= "/proj/BTC/WORK/jasons/Techfile/8M/opus/cmos14lpp_tech.layermap"

### PREPARATION ################################################################

# INITIALIZE CDS.LIB
cat "/proj/BTC/WORK/jasons/OPUS_8M/cds.lib" > cds.lib
#echo "DEFINE hce /proj/BTC/WORK/jasons/PV/TOP/btc_unit/merge/hce" >> cds.lib
#echo "INCLUDE /proj/BTC/WORK/jasons/OPUS_9M/cds.lib" >> cds.lib
cat /proj/BTC/WORK/jasons/OPUS_8M/opus_scripts/ref_lib.list > ref_lib.list
#-#-  echo "hce_0827" >> ref_lib.list
set refliblist = "./ref_lib.list"

# REMOVE READY FILE/LIB IF EXIST
[ -f gds.ready  ] && rm -f  gds.ready
[ -f gds.error  ] && rm -f  gds.error

# PREPARE WORKING DIRECTORY
[ -d PIPO ]   || mkdir PIPO

### WAIT READY FILE ############################################################

while(!(-e $ready))
echo "waiting $ready! "
sleep 100
end

echo `date` > runtime
### MERGE GDS FOR DUMMY OD/PO INSERTION ########################################

###############################
### STREAM IN ASTRO/ICC GDS ###
###############################

cat - << EOF > PIPO/strmin.${libname}_merge.run
### virtuoso strmin template file ##
### by jasons  ##
### 2015/06/17 ##
library	 "$gds_top"	      # <Destination Library>
strmFile  "$gds"	      # <Comma Seperated Quoted List of Input Stream Files>
strmTechGen		      # <Stream Tech File to be generated>
runDir     "."                #	<Run Directory>
logFile   "./PIPO/strmin.${libname}_merge.log"         #	<Output Log File Name>
topCell    ""                 # <Toplevel Cell to Translate>
view       "layout"           # <Destination View Name>
hierDepth    32               # <Hierarchical Depth to Translate to>
summaryFile   "./PIPO/top_strmin_layer.list"              # <Summary File Name>
cellMap      ""               #	<Input Cell Map File>
case         "preserve"       #	<upper | lower | preserve >
labelCase     "preserve"      #	<upper | lower | preserve >
#replaceBusBitChar            #	<Replace "[           #" With "<>">
layerMap    "$layer_map"  #	<Quoted List of Layer Map Files>
fontMap      ""               #	<Input Font Map File>
propMap      ""               #	<Input Property Map File>
objectMap    ""               #	<Object Mapping File>
viaMap       ""               # <Via Mapping File>
userSkillFile  ""             # <User Skill File>
propSeparator   ""            # <Property Separator Character>
pinAttNum      0              #	< Stream Attribute Number 0-127 >
#ignoreBoxes                  #
refLibList     "${refliblist}"             # <Name of The File Containing Refliblist>
dbuPerUU      0               #	<DB Units per user units>
scale                         #	<Design Scaling Factor>
#reportPrecisionLoss          #	<Report Precision Loss Because of dbuPerUU Value>
#keepStreamCells              #	<Keep Stream Cells>
#arrayInstToScalar            #	<Convert AREF to Scalar Instances>
attachTechFileOfLib   ""      # <Attach This Tech Lib With Target Lib>
loadTechFile        "$opus_tech"   # <ASCII Tech File>
techRefs         ""           # <Ordered List of Reference Tech Libs>
#skipUndefinedLPP             # <Donot Create Undefined LPPs in The Techfile>
#translateNode                # <Convert Node to Dot>
#ignoreZeroWidthPath          #	<Convert Zero With Path to Line>
#convertPathToPathSeg         #	<Convert 2-Point Path to PathSeg>
#snapToGrid                   # <Snap to Grid>
scaleTextHeight       "1.0"   #	<Scale Text Height (Positive Scaling Value)>
numThreads        1           #	<Nunmber of Threads Used for Translation>
enableLocking                 #	<Enable File Locking>
maxCellsInTargetLib   "20000" #	<Maximum Cells in Target Library>
#mergeUndefPurposToDrawing    #	<Merges Undefined Purposes to Drawing>
templateFile    ""            #	<Name of The File Containing Option Names And Values>
#detectVias                   #	<Detect The Via Defs And Create Them in The Database>
excludeMapToVia    ""         #	<Via exclusion Data file>
#checkPolygon                 # <Report Bad Polygons And Paths>
strmTextNS      "cdba"        # <NameSpace of The TEXT Records in The Stream File>
noInfo       ""               # <Quoted List of Info Message Ids>
noWarn       ""               #	<Quoted List of Warning Message Ids>
infoToWarn     ""             # <Quoted List of Info Message Ids>
warnToErr      ""             #	<Quoted List of Warning Message Ids>
#wildCardInCellMap            #	<Wild Card in cell map file>
compress                      #	<Allow libraries to be compressed>
compressLevel                 #	<Defines the compression level to use (default: 1)>
enableIncrementalImport       #	<Enable incremental import of multiple Stream Files>
writeMode                     # <Write Mode (overwrite|noOverwrite|append|rename) for Existing Cells (default: overwrite)>
#overwriteRootCells           #	<Overwrite the root/top Cells in case writeMode is rename>
enableColoring                # <Enable Coloring Support>

EOF

strmin -templateFile  PIPO/strmin.${libname}_merge.run




######Merge Dodpo library######
source /filer/home/jasons/virtuso.lic
cat << EOF > PIPO/GUARD.il
cv = dbOpenCellViewByType("${libname}" "${IP_merge_top}" "layout" "maskLayout" "a")
unless(cv return())
dpo = dbOpenCellView("${guardlib}" "${Guard_top}" "layout")
dbCreateInst(cv dpo nil list(0.0 0.0) "R0")
dbSave(cv)
dbClose(cv)
exit

EOF

layout -64 -log PIPO/merge_guard.log  -nograph -replay PIPO/GUARD.il

##strmout final gds##

cat - << EOF > PIPO/strmout.${libname}_final.run
### virtuoso strmout template file ##
### by jasons  ##
### 2015/0617 ##
library		"$libname"        #<Input Library>
strmFile	"./$final"     	   #<Output Stream File>
strmVersion	5	           #<Stream Version Number>
runDir		"."                #<Run Directory>
topCell		"$final_top"        #<Toplevel Cells to Translate>
view		"layout"	   #<Toplevel Cell View Name>
logFile		"PIPO/strmout.${libname}_final.log"        #<Output Log File Name>
summaryFile	"./PIPO/top_strmout_layer.list"	           #<Output Summary File>
techLib		""	           #<Technology Library>
hierDepth	32	           #<Hierarchical Depth to Translate to>
layerMap	"$layer_map"   #<Quoted List of Layer Map Files>
labelMap	""	#<Input Label Map File>
labelDepth	"1"	#<Hierarchical Depth to Add Labels to>
#replaceBusBitChar	#<Replace "<>" With "[">
cellMap		""	#<Input Cell Map File>
fontMap		""	#<Input Font Map File>
propMap		""	#<Input Property Map File>
objectMap	""	#<Quoted List of Object Mapping Files>
viaMap		""	#<Via Mapping File>
viaCutArefThreshold ""	#<Threshold Value For Creating AREF For Cut Geometries For Via>
userSkillFile	""	#<User Skill File>
refLibList	""	#<Name of The File Containing Refliblist >
#arrayInstToScalar
cellNamePrefix	""	#<Cell Name Prefix>
cellNameSuffix	""	#<Cell Name Suffix>
#ignoreTopCellPrefixSuffix  #<Ignore cellName Prefix and Suffix for topCell>
case		"preserve"	#<upper | lower | preserve >
labelCase	"preserve"	#<upper | lower | preserve >
#ignoreLines
#noOutputTextDisplays
#noOutputUnplacedInst	#<Do not Output Unplaced Instances>
convertDot	"ignore"	#<node | polygon | ignore >
convertPin	"geometry"	#<geometry | text | geometryAndText | ignore >
pinAttNum	"0"	#<Stream Attribute Num (1-127) For Preserving Pins>
#pathToPolygon
#propValueOnly		#<Output Property Values Only>
#rectToBox
#respectGDSIINameLimit
gdsCellNameLength	#<Truncate GDS Cell/STRUCT name length to specified value (>=10)>
#flattenPcells
#flattenVias
#doNotPreservePcellPins
#snapToGrid
dbuPerUU	0	#<DB Units per user units>
#reportPrecisionLoss	#<Report Precision Loss Because of dbuPerUU Value>
#noObjectProp
#ignorePcellEvalFail
#mergePathSegsToPath	#<Merging pathSegs into a single PATH>
#noConvertHalfWidthPath	#<Do not Convert The Half Width Path to Boundary>
#checkPolygon		#<Report Bad Polygons And Paths>
#backupGdsLogFiles	#	<Backup GDSII and LOG files, if they already exist>
maxVertices	200	#<Maximum Limit of Vertices (5-4000) Allowed in Stream File>
strmTextNS	"cdba"	#<NameSpace of The TEXT Records in The Stream File>
templateFile	""	#<Name of The File Containing Option Names And Values>
cellListFile	""	#<Name of the file containing cellList>
outputDir	""	#<output directory>
noInfo		""	#<Quoted List of Info Message Ids>
noWarn		""	#<Quoted List of Warning Message Ids>
warnToErr	""	#<Quoted List of warning Message Ids>
infoToWarn	""	#<Quoted List of Info Message Ids>
donutNumSides	""	#<Number of sides (Positive value) for the BOUNDARY of donut>
ellipseNumSides	""	#<Number of sides (Positive value) for the BOUNDAR of ellipse>
#wildCardInCellMap	#<Wild Card in cell map file>
#ignoreMissingCells	#<Ignore Missing cellViews During Translation and Continue Translation>
subMasterSeparator	#<Separator to used for sub-master naming (default: "_CDNS_")>
enableColoring		#<Enable Coloring Support>

EOF

strmout -templateFile PIPO/strmout.${libname}_final.run


if (-e ${final}) then
	gzip ${final}
	touch gds.ready
	else
	touch gds.error
	endif
echo `date` >> runtime
