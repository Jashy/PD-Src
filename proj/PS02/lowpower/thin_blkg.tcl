###################################################################

# Created by write_floorplan on Sun Dec  6 19:23:18 2015

###################################################################
undo_config -disable

#remove_die_area 

#create_die_area  \
	-poly {	{0.000 0.000} {0.000 2944.800} {760.840 2944.800} {760.840 2901.600} {1608.960 2901.600} {1608.960 2944.800} {2152.020 2944.800} {2152.020 2901.600} {4370.080 2901.600} {4370.080 0.000} {0.000 0.000}} 
set oldSnapState [set_object_snap_type -enabled false]

#************************
#  Placement Blockage  
# obj#: 244 
# objects are in positional ordering 
#************************

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#0 \
	-coordinate {{33.547 656.258} {41.547 792.552}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#1 \
	-coordinate {{35.437 793.552} {48.437 1489.076}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#2 \
	-coordinate {{39.343 2558.134} {54.343 2944.260}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#3 \
	-coordinate {{52.686 560.298} {65.686 618.150}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#4 \
	-coordinate {{61.884 1478.914} {83.622 1631.694}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#5 \
	-coordinate {{71.548 0.260} {89.548 552.298}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#6 \
	-coordinate {{107.121 656.258} {115.121 792.552}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#7 \
	-coordinate {{116.909 1361.052} {137.734 1420.262}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#8 \
	-coordinate {{117.791 793.552} {130.791 1361.052}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#9 \
	-coordinate {{123.697 2558.134} {138.697 2944.260}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#14_2 \
	-coordinate {{198.255 1276.162} {213.145 1322.717}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#13 \
	-coordinate {{200.145 792.552} {200.146 1166.516}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#11_1 \
	-coordinate {{200.146 792.552} {213.145 959.915}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#11_2 \
	-coordinate {{200.146 959.915} {215.035 1113.641}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#14_3 \
	-coordinate {{200.146 1113.641} {211.255 1223.287}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#14_4 \
	-coordinate {{200.146 1223.287} {213.145 1276.162}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#16 \
	-coordinate {{211.957 2541.648} {224.957 2944.260}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#17 \
	-coordinate {{231.124 0.260} {249.124 552.298}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#20_2 \
	-coordinate {{278.719 1237.569} {288.609 1301.177}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#19 \
	-coordinate {{280.609 754.501} {288.609 889.795}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#20_1 \
	-coordinate {{280.609 992.629} {288.609 1237.569}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#21 \
	-coordinate {{285.566 689.893} {293.566 753.501}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#22 \
	-coordinate {{292.818 890.795} {309.818 991.629}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#23 \
	-coordinate {{346.988 1128.923} {371.268 1226.021}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#24 \
	-coordinate {{354.183 754.501} {362.183 889.795}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#25 \
	-coordinate {{354.183 992.629} {362.183 1128.923}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#26 \
	-coordinate {{359.140 677.111} {367.140 753.501}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#27 \
	-coordinate {{390.700 0.260} {408.700 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#28 \
	-coordinate {{399.810 890.795} {412.810 991.629}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#29 \
	-coordinate {{427.757 754.501} {435.757 889.795}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#30 \
	-coordinate {{427.757 987.893} {441.044 1084.991}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#31 \
	-coordinate {{432.714 677.111} {440.714 753.501}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#32 \
	-coordinate {{441.044 890.795} {449.044 1084.991}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#34 \
	-coordinate {{501.331 754.501} {509.331 872.363}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#35 \
	-coordinate {{506.288 677.111} {514.288 753.501}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#36 \
	-coordinate {{534.060 2546.270} {547.060 2944.260}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#37 \
	-coordinate {{550.276 0.260} {568.276 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#38 \
	-coordinate {{574.905 754.501} {582.905 953.361}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#40 \
	-coordinate {{579.862 677.111} {607.317 753.501}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#39 \
	-coordinate {{582.905 872.363} {582.906 953.361}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#41 \
	-coordinate {{612.634 2639.632} {625.634 2712.456}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#42 \
	-coordinate {{616.414 2724.022} {629.414 2944.260}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#43 \
	-coordinate {{641.532 2546.270} {656.532 2638.632}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#44 \
	-coordinate {{650.369 754.501} {663.369 954.307}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#45 \
	-coordinate {{659.737 1627.805} {680.467 1751.767}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#46 \
	-coordinate {{661.122 955.307} {669.122 1018.915}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#47 \
	-coordinate {{693.914 1059.305} {706.914 1626.805}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#48 \
	-coordinate {{699.795 1788.839} {707.795 1970.309}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#49 \
	-coordinate {{707.795 1906.701} {708.803 1970.309}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#50 \
	-coordinate {{709.852 0.260} {727.852 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#51 \
	-coordinate {{711.169 663.497} {728.169 753.501}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#52 \
	-coordinate {{732.723 754.501} {745.723 954.307}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#53 \
	-coordinate {{748.390 955.307} {756.390 1018.915}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#33 \
	-coordinate {{756.390 1036.305} {824.445 1059.305}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#54 \
	-coordinate {{769.324 1957.635} {791.158 2016.845}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#55 \
	-coordinate {{776.267 1756.829} {776.268 1943.811}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#56 \
	-coordinate {{776.267 1943.811} {791.158 1957.635}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#57 \
	-coordinate {{776.268 1059.305} {789.268 1943.811}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#58 \
	-coordinate {{815.077 754.501} {828.077 954.307}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#59 \
	-coordinate {{821.964 955.307} {829.964 1036.305}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#60 \
	-coordinate {{869.428 0.260} {887.428 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#61 \
	-coordinate {{922.375 2551.798} {935.375 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#62 \
	-coordinate {{1004.729 2551.798} {1017.729 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#63 \
	-coordinate {{1029.004 0.260} {1047.004 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#64 \
	-coordinate {{1032.234 1959.289} {1040.234 2368.171}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#65 \
	-coordinate {{1060.523 787.569} {1068.523 924.905}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#66 \
	-coordinate {{1072.785 925.905} {1089.785 1958.289}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#67 \
	-coordinate {{1087.083 2551.798} {1104.083 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#68 \
	-coordinate {{1089.995 579.855} {1095.995 681.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#69 \
	-coordinate {{1105.808 1959.289} {1113.808 2368.171}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#70 \
	-coordinate {{1147.095 2204.671} {1394.157 2229.835}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#71 \
	-coordinate {{1170.297 1374.619} {1178.297 1490.661}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#72 \
	-coordinate {{1173.437 2551.798} {1190.437 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#73 \
	-coordinate {{1181.272 1491.661} {1194.272 2204.671}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#74 \
	-coordinate {{1186.229 2229.835} {1194.229 2368.171}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#75 \
	-coordinate {{1188.580 0.260} {1206.580 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#76 \
	-coordinate {{1225.701 1374.619} {1233.701 1490.661}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#77 \
	-coordinate {{1259.791 2551.798} {1276.791 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#78 \
	-coordinate {{1263.626 1491.661} {1276.626 2204.671}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#79 \
	-coordinate {{1273.497 2229.835} {1281.497 2368.171}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#80 \
	-coordinate {{1281.105 1374.619} {1289.105 1490.661}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#81 \
	-coordinate {{1345.980 1490.661} {1358.980 2204.671}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#82 \
	-coordinate {{1346.145 2551.798} {1363.145 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#83 \
	-coordinate {{1348.156 0.260} {1366.156 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#84 \
	-coordinate {{1360.765 2229.835} {1368.765 2368.171}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#85 \
	-coordinate {{1394.157 2202.863} {1486.425 2229.835}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#86 \
	-coordinate {{1426.444 2112.649} {1453.138 2202.863}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#87 \
	-coordinate {{1428.334 1490.661} {1441.334 1966.001}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#88 \
	-coordinate {{1432.499 2551.798} {1449.499 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#89 \
	-coordinate {{1433.291 1967.001} {1446.291 2112.649}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#90 \
	-coordinate {{1439.713 2229.835} {1447.713 2368.171}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#91 \
	-coordinate {{1507.732 0.260} {1520.732 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#92 \
	-coordinate {{1510.688 1490.661} {1523.688 1966.001}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#93 \
	-coordinate {{1518.712 2103.295} {1533.728 2193.509}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#94 \
	-coordinate {{1518.853 2551.798} {1535.853 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#95 \
	-coordinate {{1519.720 1967.001} {1532.720 2103.295}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#96 \
	-coordinate {{1593.042 1490.661} {1606.042 1966.001}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#97 \
	-coordinate {{1599.302 1967.001} {1614.825 2147.429}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#98 \
	-coordinate {{1605.207 2551.798} {1622.207 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#99 \
	-coordinate {{1613.450 549.448} {1630.450 820.420}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#100 \
	-coordinate {{1662.308 0.260} {1680.308 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#101 \
	-coordinate {{1675.396 1490.661} {1688.396 1967.001}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#102 \
	-coordinate {{1685.162 549.448} {1711.162 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#103 \
	-coordinate {{1691.561 2551.798} {1708.561 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#104 \
	-coordinate {{1735.800 1490.661} {1743.800 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#105 \
	-coordinate {{1753.970 2009.315} {1761.970 2094.921}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#106 \
	-coordinate {{1757.750 1607.703} {1770.750 2008.315}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#107 \
	-coordinate {{1765.874 549.448} {1791.874 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#108 \
	-coordinate {{1777.915 2551.798} {1794.915 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#109 \
	-coordinate {{1791.204 1490.661} {1799.204 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#110 \
	-coordinate {{1821.884 0.260} {1839.884 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#111 \
	-coordinate {{1827.544 2009.315} {1835.544 2094.921}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#112 \
	-coordinate {{1840.104 1607.703} {1853.104 2008.315}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#113 \
	-coordinate {{1846.586 549.448} {1872.586 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#114 \
	-coordinate {{1846.608 1490.661} {1854.608 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#115 \
	-coordinate {{1855.599 982.823} {1863.599 1065.306}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#116 \
	-coordinate {{1864.269 2551.798} {1881.269 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#117 \
	-coordinate {{1901.118 2009.315} {1909.118 2094.921}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#118 \
	-coordinate {{1902.012 1490.661} {1910.012 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#119 \
	-coordinate {{1922.458 1607.703} {1935.458 2008.315}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#120 \
	-coordinate {{1927.298 549.448} {1954.298 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#121 \
	-coordinate {{1950.623 2551.798} {1967.623 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#122 \
	-coordinate {{1965.102 1488.283} {1973.102 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#123 \
	-coordinate {{1974.692 2009.315} {1982.692 2094.921}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#124 \
	-coordinate {{1981.460 0.260} {1999.460 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#125 \
	-coordinate {{1990.679 982.823} {2007.679 1157.081}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#126 \
	-coordinate {{2004.812 1607.703} {2017.812 2008.315}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#127 \
	-coordinate {{2009.010 549.448} {2036.010 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#128 \
	-coordinate {{2035.878 1488.283} {2043.878 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#129 \
	-coordinate {{2036.977 2551.798} {2053.977 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#130 \
	-coordinate {{2048.266 2009.315} {2056.266 2094.921}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#131 \
	-coordinate {{2087.166 1607.703} {2100.166 2008.315}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#132 \
	-coordinate {{2090.722 549.448} {2117.722 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#133 \
	-coordinate {{2106.654 1488.283} {2112.818 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#134 \
	-coordinate {{2117.091 2551.798} {2130.091 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#135 \
	-coordinate {{2121.840 2009.315} {2129.386 2082.139}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#136 \
	-coordinate {{2141.036 0.260} {2159.036 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#137 \
	-coordinate {{2169.520 1607.703} {2182.520 2082.139}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#139 \
	-coordinate {{2172.434 549.448} {2199.434 820.520}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#140 \
	-coordinate {{2176.993 1470.409} {2184.993 1606.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#138 \
	-coordinate {{2182.520 1845.373} {2183.402 2082.139}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#141 \
	-coordinate {{2186.965 2551.798} {2199.965 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#143_2 \
	-coordinate {{2247.714 1607.703} {2264.714 2156.771}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#143_1 \
	-coordinate {{2251.575 1518.793} {2264.714 1607.703}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#144 \
	-coordinate {{2254.146 549.448} {2272.146 820.420}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#145 \
	-coordinate {{2256.839 2551.798} {2269.839 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#146 \
	-coordinate {{2269.458 0.260} {2287.458 371.796}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#147 \
	-coordinate {{2326.713 2551.798} {2339.713 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#148 \
	-coordinate {{2402.827 2551.798} {2415.827 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#149 \
	-coordinate {{2485.181 2551.798} {2498.181 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#150 \
	-coordinate {{2525.196 0.260} {2543.196 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#151 \
	-coordinate {{2567.535 2551.798} {2580.535 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#152 \
	-coordinate {{2569.563 1631.380} {2580.563 1961.210}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#153 \
	-coordinate {{2569.563 1961.210} {2579.611 1962.210}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#154 \
	-coordinate {{2619.745 1962.210} {2634.745 2207.288}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#155 \
	-coordinate {{2634.745 2152.074} {2648.231 2207.288}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#156 \
	-coordinate {{2649.889 2551.798} {2662.889 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#157 \
	-coordinate {{2649.917 1632.380} {2662.917 1961.210}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#158 \
	-coordinate {{2672.122 1534.282} {2680.122 1631.380}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#159 \
	-coordinate {{2684.772 0.260} {2702.772 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#160 \
	-coordinate {{2698.094 1980.642} {2713.236 2258.994}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#161 \
	-coordinate {{2724.410 1072.394} {2741.410 1246.652}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#162 \
	-coordinate {{2729.671 1632.380} {2742.671 1979.642}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#163 \
	-coordinate {{2732.243 2551.798} {2745.243 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#164 \
	-coordinate {{2734.834 1534.282} {2742.834 1631.380}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#165 \
	-coordinate {{2734.834 1631.380} {2742.671 1632.380}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#166 \
	-coordinate {{2777.390 1980.642} {2790.390 2328.904}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#167 \
	-coordinate {{2797.546 1496.394} {2824.546 1631.380}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#168 \
	-coordinate {{2806.825 1631.380} {2819.825 1979.642}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#169 \
	-coordinate {{2809.766 509.340} {2817.766 643.068}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#170 \
	-coordinate {{2844.348 0.260} {2862.348 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#171 \
	-coordinate {{2854.544 1980.642} {2867.544 2328.904}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#172 \
	-coordinate {{2897.034 509.340} {2905.034 633.852}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#173 \
	-coordinate {{2986.793 2551.798} {2999.793 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#174 \
	-coordinate {{3003.924 0.260} {3021.924 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#175 \
	-coordinate {{3069.147 2551.798} {3082.147 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#176 \
	-coordinate {{3105.434 1072.394} {3118.434 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#177 \
	-coordinate {{3151.501 2551.798} {3164.501 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#178 \
	-coordinate {{3161.981 1631.380} {3172.981 2328.904}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#179 \
	-coordinate {{3163.500 0.260} {3181.500 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#180 \
	-coordinate {{3187.788 1072.394} {3200.788 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#181 \
	-coordinate {{3189.496 509.340} {3200.496 932.330}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#182 \
	-coordinate {{3233.855 2551.798} {3246.855 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#183 \
	-coordinate {{3237.135 1631.380} {3248.135 1979.642}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#184 \
	-coordinate {{3240.255 1980.642} {3251.255 2328.904}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#185 \
	-coordinate {{3270.142 1072.394} {3283.142 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#186 \
	-coordinate {{3284.887 509.340} {3292.887 941.684}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#187 \
	-coordinate {{3316.209 2643.958} {3331.209 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#188 \
	-coordinate {{3323.076 0.260} {3341.076 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#189 \
	-coordinate {{3352.496 1072.394} {3365.496 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#190 \
	-coordinate {{3392.315 509.340} {3405.315 858.602}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#191 \
	-coordinate {{3434.850 1072.394} {3447.850 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#192 \
	-coordinate {{3474.669 509.340} {3491.669 858.602}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#193 \
	-coordinate {{3482.652 0.260} {3500.652 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#194 \
	-coordinate {{3517.204 1072.394} {3530.204 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#195 \
	-coordinate {{3527.736 2115.833} {3535.736 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#196 \
	-coordinate {{3541.277 2643.958} {3556.277 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#197 \
	-coordinate {{3561.023 509.340} {3578.023 858.602}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#198 \
	-coordinate {{3586.750 2115.833} {3594.750 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#199 \
	-coordinate {{3599.558 1072.394} {3612.558 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#200 \
	-coordinate {{3630.702 1814.094} {3638.703 1831.526}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#201 \
	-coordinate {{3630.702 1831.526} {3638.702 1913.524}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#202 \
	-coordinate {{3630.703 1614.234} {3638.703 1814.094}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#203 \
	-coordinate {{3642.228 0.260} {3660.228 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#204 \
	-coordinate {{3645.764 2115.833} {3653.764 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#205 \
	-coordinate {{3647.377 509.340} {3664.377 858.602}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#206 \
	-coordinate {{3681.912 1072.394} {3694.912 1310.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#207 \
	-coordinate {{3701.912 1311.064} {3709.912 1438.142}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#208 \
	-coordinate {{3704.087 1614.234} {3717.087 1991.144}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#209 \
	-coordinate {{3704.778 2115.833} {3712.778 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#210 \
	-coordinate {{3763.792 2115.833} {3771.792 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#211 \
	-coordinate {{3764.266 1072.394} {3777.266 1310.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#212 \
	-coordinate {{3781.786 1311.064} {3789.786 1438.142}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#213 \
	-coordinate {{3786.187 1614.234} {3799.187 1986.536}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#214 \
	-coordinate {{3801.804 0.260} {3819.804 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#215 \
	-coordinate {{3821.276 2562.740} {3829.276 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#216 \
	-coordinate {{3822.806 2115.833} {3830.806 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#217 \
	-coordinate {{3846.620 1072.394} {3859.620 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#218 \
	-coordinate {{3881.820 2115.833} {3889.820 2368.327}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#219 \
	-coordinate {{3928.974 1072.394} {3941.974 1311.064}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#220 \
	-coordinate {{3961.380 0.260} {3979.380 365.952}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#221 \
	-coordinate {{4011.328 1072.394} {4022.328 1269.592}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#222 \
	-coordinate {{4060.710 2799.588} {4068.710 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#224 \
	-coordinate {{4108.844 2799.588} {4116.844 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#225 \
	-coordinate {{4120.956 0.260} {4138.956 552.298}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#226 \
	-coordinate {{4156.978 2799.588} {4164.978 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#227 \
	-coordinate {{4235.289 1722.214} {4248.289 2071.476}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#228 \
	-coordinate {{4239.289 2551.798} {4252.289 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#223 \
	-coordinate {{4246.144 1092.034} {4286.359 1108.858}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#229 \
	-coordinate {{4259.378 1316.326} {4267.378 1719.214}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#230 \
	-coordinate {{4259.378 2074.476} {4267.378 2477.364}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#231 \
	-coordinate {{4278.358 1204.680} {4286.358 1316.326}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#232 \
	-coordinate {{4278.359 1108.858} {4286.359 1203.680}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#233 \
	-coordinate {{4278.359 1203.680} {4286.358 1204.680}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#234 \
	-coordinate {{4280.532 0.260} {4298.532 924.990}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#235 \
	-coordinate {{4290.196 989.200} {4308.196 1095.034}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#236 \
	-coordinate {{4317.643 1722.214} {4334.643 2071.476}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#237 \
	-coordinate {{4321.643 2551.798} {4334.643 2901.060}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#238 \
	-coordinate {{4330.006 1316.326} {4338.006 1719.214}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#239 \
	-coordinate {{4330.006 2074.476} {4338.006 2477.364}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#240 \
	-coordinate {{4336.332 1204.680} {4344.332 1312.326}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#241 \
	-coordinate {{4336.333 1095.034} {4344.333 1203.680}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#242 \
	-coordinate {{4336.333 1203.680} {4344.332 1204.680}} 

create_placement_blockage  \
	-type hard \
	-name ICC_THIN_CHAN_PLACE_BLKG_#243 \
	-coordinate {{4369.619 2071.476} {4369.820 2074.476}} 


set_object_snap_type -enabled $oldSnapState
undo_config -enable
