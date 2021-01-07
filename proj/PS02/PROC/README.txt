ICC PSYN Basic Flow:
------------------------------------------------------------------
NOTE:
This is only a general flow, please add or remove some commands if
necessary.
------------------------------------------------------------------

main scripts:
run_all.csh    ## main script to run all the step
des.tcl        ## varibles setting used in the design

In the run_all.csh script, you can find below variables setting:

set crt_design = 1
set place_opt  = 1
set route      = 1
set route_opt  = 1

you can choose "1" to run the section, or "0" to skip the section


STEP:
------------------------------------------------------------------
1.create_design
function: create the design with netlist and floorplan def
related scripts:
/proj/WyvernES2/iTitan/TEMPLATES/ICC/tcl/create_mdb.tcl    ##Create the LIBRARY
/proj/WyvernES2/iTitan/TEMPLATES/ICC/tcl/read_design.tcl   ##Read Netlist & SDC
/proj/WyvernES2/iTitan/TEMPLATES/ICC/tcl/read_fp.tcl       ##Read Floorplan

2.place_opt
function: place the std cell and do optimization
related scripts:
/proj/WyvernES2/iTitan/TEMPLATES/ICC/tcl/place_opt.tcl    ##Do Physical Synthesis

3.route
function: route the clock/signal nets
related scripts:
/proj/WyvernES2/iTitan/TEMPLATES/ICC/tcl/route.tcl        ##Route Clock/Signal Nets

4.route_opt
function: postroute opt
related scripts:
/proj/WyvernES2/iTitan/TEMPLATES/ICC/tcl/route_opt.tcl    ##Run Postroute opt
