#! /bin/csh
set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/ml_cworst_125C_sdf/OUTPUT/ptile_top.ml_cworst_125C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/ml_cworst/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/ml_cbest_125C_sdf/OUTPUT/ptile_top.ml_cbest_125C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/ml_cbest/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/wcz_cworst_0C_sdf/OUTPUT/ptile_top.wcz_cworst_0C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/wcz_cworst/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/wc_cworst_125C_sdf/OUTPUT/ptile_top.wc_cworst_125C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/wc_cworst/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/wc_cbest_125C_sdf/OUTPUT/ptile_top.wc_cbest_125C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/wc_cbest/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/bc_cbest_0C_sdf/OUTPUT/ptile_top.bc_cbest_0C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/bc_cbest/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/bc_cworst_0C_sdf/OUTPUT/ptile_top.bc_cworst_0C
perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/bc_cworst/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl

#set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/ml_cworst_125C_sdf/OUTPUT/ptile_top.ml_cworst_125C
#perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/ml_cworst/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl
#
#set pvt_wire = /proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/ml_cbest_125C_sdf/OUTPUT/ptile_top.ml_cbest_125C
#perl /proj/Pezy-1/WORK/jimmyx/SIGS/fix_multi_driven.pl /proj/Pezy-1/WORK/carson/ptile_top/SIGS/20111122a/ptile_top/ml_cbest/Pezy-1.multi_drive.log ${pvt_wire}.sdf.gz ${pvt_wire}_nomulti.sdf.gz remove_para.tcl
