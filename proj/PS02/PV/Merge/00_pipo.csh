#!/bin/csh -f

source ./common_setting.csh
source $lic_global
#source /filer/home/allena/IC_615/virtuso.lic


set WAIT_FILE  =  /DELL/proj/PS02/WORK/jasons/Block/GAIA/ECO_0227a/GAIA-VCF_DFT_1218-FCF_DFT_1218-SCF_DFT_my_0202-jasons-ECO_0202_lukez/release/gds_ready
while ( !( -e ${WAIT_FILE} ) )
  echo "Wating ${WAIT_FILE} get ready."
  sleep 30
end


cp /proj/PS02/LIB/20150116/DK_PS02/lib/opus/cds/cds_20160202a.lib ./cds.lib

pi.sh -t ${opus_tech_file} -L -m ${opus_map_file} ${TOP} $icc_gds
po.sh -p ${TOP} -m ${opus_map_file} ${TOP} ${TOP}_oa.gds.gz

touch oa_ready

