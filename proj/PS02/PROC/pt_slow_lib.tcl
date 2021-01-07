set designer { Alchip }
set company  { Alchip/Cinnamon }

set timing_update_status_level high

history keep 100

set search_path { . \
        /proj/Cinnamon/CURRENT/LIB/6T/CURRNET/1P-RF/synopsys \
        /proj/Cinnamon/CURRENT/LIB/6T/CURRNET/1P-SRAM/synopsys \
        /proj/Cinnamon/CURRENT/LIB/6T/CURRNET/2P-SRAM/synopsys \
        /proj/Cinnamon/CURRENT/LIB/6T/CURRNET/2P-RF/synopsys \
        /proj/Cinnamon/CURRENT/LIB/1TR//CURRNET/synopsys \
	/proj/Cinnamon/CURRENT/LIB/SC/CURRNET/ts13ugfhdusa01/liberty/2001.08 \
	/proj/Cinnamon/CURRENT/LIB/SC/CURRNET/ts13ugfsdusa03/liberty/2001.08 \
	/proj/Cinnamon/CURRENT/LIB/ADC/CURRNET/synopsys \
	/proj/Cinnamon/CURRENT/LIB/IO/CURRNET/synopsys \
	/proj/Cinnamon/CURRENT/LIB/PLL/CURRNET/synopsys \
	/proj/Cinnamon/CURRENT/LIB/CHIPID/CURRNET/synopsys \
}

set link_path " * \
	tsmc013_32kx32_wc.db \
	tsmc013_48kx32_wc.db \
	tsmc013_8kx128_wc.db \
	RF1P128X256.db \
	RF1P24X32.db \
	RF1P32X180.db \
	RF1P32X512WP8.db \
	RF1P41X128.db \
	RF1P64X512.db \
	RF1P8X368.db \
	RF1P12X384.db \
	RF1P26X64.db \
	RF1P32X256.db \
	RF1P32X64WP8.db \
	RF1P41X256.db \
	RF1P64X64WP8.db \
	RF1P22X128.db \
	RF1P30X64.db \
	RF1P32X32WP8.db \
	RF1P39X256.db \
	RF1P43X128.db \
	RF1P8X128WP1.db \
	RF1P22X256.db \
	RF1P32X16.db \
	RF1P32X512.db \
	RF1P40X180.db \
	RF1P45X64.db \
	RF1P8X32.db \
	SRAM1P128X1024.db \
	SRAM1P32X1024WP8.db \
	SRAM1P32X2048WP8.db \
	SRAM1P32X1024.db \
	SRAM1P32X1312WP8.db \
	SRAM1P64X1024.db \
	RF2P12X128.db \
	RF2P24X144.db \
	RF2P32X100.db \
	RF2P32X16.db \
	RF2P32X480.db \
	RF2P32X80.db \
	RF2P8X256.db \
	RF2P18X96.db \
	RF2P24X96.db \
	RF2P32X128.db \
	RF2P32X256.db \
	RF2P32X512.db \
	RF2P32X96.db \
	RF2P8X384.db \
	SRAMDP10X192.db \
	SRAMDP14X256.db \
	SRAMDP21X512.db \
	SRAMDP8X128.db \
	SRAMDP8X720.db \
	SRAMDP9X768.db \
	SRAMDP12X768.db \
	SRAMDP16X1280.db \
	SRAMDP8X1024.db \
	SRAMDP8X256.db \
	SRAMDP8X768.db \
	TS200XN2ASAP02.db \
	drmcidt640_ss.db \
	ts13ugfhdus_ss.db \
	ts13ugfsdus_ss.db \
	TS70XS2PFC100.db \
	snyg13f843t3_wc_108V_125C.db \
	arti_tsm13_sp_syn_ss_i.db \
"