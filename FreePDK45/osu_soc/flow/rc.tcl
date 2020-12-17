#**************************************************/
#* Script for Cadence RTL Compiler synthesis      */
#*                                                */
#* To run: rc < rc.tcl                            */
#*                                                */
#* Author: Ivan Castellanos, OSU                  */
#* ivan.castellanos@okstate.edu                   */
#**************************************************/

# All HDL files, separated by spaces
set hdl_files {FILE1.v FILE2.v}

# The Top-level Module, change example multiplyadd
set DESIGN TOPLEVEL_MODULE

# Set clock pin name in design. If clk just leave untouched,
# otherwise change clk
set clkpin clk

# Target frequency in MHz for optimization
set delay 100

#**************************************************/
# NO further changes past this point

set osucells $env(PDK_DIR)/osu_soc

set_attribute hdl_search_path {./} /
set_attribute lib_search_path ./ /

set_attribute information_level 6 /

set_attribute library gscl45nm.lib
read_hdl ${hdl_files}

elaborate $DESIGN

# Apply Constraints

set clock [define_clock -period ${delay} -name ${clkpin} [clock_ports]]	
external_delay -input   0 -clock clk [find / -port ports_in/*]
external_delay -output  0 -clock clk [find / -port ports_out/*]
# Sets transition to default values for Synopsys SDC format, fall/rise
# 400ps
dc::set_clock_transition .4 clk

check_design -unresolved

report timing -lint

#*Synthesis
synthesize -to_mapped

report timing > timing.rep
report gates  > cell.rep
report power  > power.rep

write_hdl -mapped >  ${DESIGN}.vh
write_sdc >  ${DESIGN}.sdc

puts \n 
puts "Synthesis Finished!         "
puts \n
puts "Check timing.rep, area.rep, gate.rep and power.rep for synthesis results"
puts \n
 
quit
