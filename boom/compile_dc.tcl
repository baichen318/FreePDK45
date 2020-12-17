#/**************************************************/
#/* Compile Script for Synopsys                    */
#/*                                                */
#/* dc_shell-t -f compile_dc.tcl                   */
#/*                                                */
#/* OSU FreePDK 45nm                               */
#/**************************************************/

#/* Useful macors */
set long_name chipyard.TestHarness.SmallBoomConfig
set tb_prefix TestHarness.dut

#/* All verilog files, separated by spaces         */
set my_verilog_files [list src/$long_name.top.v \
                           src/$long_name.top.mems.v \
						   src/$long_name.harness.v \
						   src/$long_name.harness.mems.v \
						   src/EICG_wrapper.v \
						   src/IOCell.v \
						   src/plusarg_reader.v \
						   src/SimDRAM.v \
						   src/SimSerial.v \
						   src/SimUART.v \
						   src/TestDriver.v]

#/* Top-level Module                               */
set my_toplevel ChipTop

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clock

#/* Target frequency in MHz for optimization       */
set my_clk_freq_MHz 800

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0.1

#/* Set the output directory   */
set report_dir reports

#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/
set OSU_FREEPDK [format "%s%s"  [getenv "PDK_DIR"] "/osu_soc/lib/files"]
set search_path [concat  $search_path $OSU_FREEPDK]
set alib_library_analysis_path $OSU_FREEPDK

set link_library [set target_library [concat  [list gscl45nm.db] [list dw_foundation.sldb]]]
set target_library "gscl45nm.db"
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"

analyze -f verilog $my_verilog_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

set my_period [expr 1000 / $my_clk_freq_MHz]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

#/* You can execute this command instead of `compile` to see the difference */
# compile_ultra -gate_clock -no_autoungroup
compile

check_design

change_names -rules verilog -hierarchy

#/* Output */
file mkdir $report_dir

set_svf -off

set filename [format "%s/%s%s" $report_dir $my_toplevel ".ddc"]
write -format ddc -hierarchy -output $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".v"]
write -f verilog -hierarchy -output $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".fp"]
write_floorplan -all $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".sdf"]
write_sdf $filename

set filename [format "%s/%s%s"  $report_dir $my_toplevel ".sdc"]
write_sdc $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".spef"]
write_parasitics -output $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".qor.rpt"]
report_qor > $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".timing.rpt"]
report_timing -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 10 -max_paths 500 > $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".area.rpt"]
report_area -hierarchy -physical -nosplit > $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".power.rpt"]
report_power -nosplit -hier > $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".reference.rpt"]
report_reference -nosplit -hierarchy > $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".resources.rpt"]
report_resources -nosplit -hierarchy > $filename

set filename [format "%s/%s%s" $report_dir $my_toplevel ".constraints.rpt"]
report_constraint > $filename

#/* Simulation needed */
proc find_regtb_prefix 			 \
			tb_prefix 			 \
			{force_val 0} 		 \
			{force_script "force_regs.ucli"} \
			{pli_tab_file "access.tab"}} {

  set regs ""
  set refs ""
  foreach_in_collection reg [all_registers] {
    # Keep a list of all the library cell names in the design
    if { [lsearch $refs [get_attribute $reg ref_name]] == -1 } {
      lappend refs [get_attribute $reg ref_name]
    }
    # Keep a list of all the register pathnames in the design
    foreach pins [get_object_name [filter [get_pins -of_object $reg] {@pin_direction == out}]] {
      lappend regs $pins
    }
  }
  redirect $force_script {echo ""}
  foreach myreg $regs {
    # DC/ICC hierarchical separator is "/", but VCS needs "."
    regsub -all {/}  $myreg . thisreg
    # Some pins might have "[" or "]", which will confuse ucli
    regsub -all {\[} $thisreg \\\[ this_reg
    regsub -all {\]} $this_reg \\\] thisreg
    redirect -append $force_script {echo "force -deposit ${tb_prefix}.${thisreg} $force_val"}
  }

  redirect $pli_tab_file {echo ""}
  foreach myref $refs {
    redirect -append $pli_tab_file {echo "acc+=wn:$myref"}
  }
}

find_regs $tb_prefix

# quit

