# Author: baichen318@gmail.com

default: all

base_dir := $(shell pwd)/..
src := $(base_dir)/src

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

include $(base_dir)/Makefrag

# Library components

vclib := $(src)/vclib
vclib_srcs = \
	$(vclib)/vcQueues.v \
	$(vclib)/vcStateElements.v \
	$(vclib)/vcTest.v \
	$(vclib)/vcTestSource.v \
	$(vclib)/vcTestSink.v \

# Specify what the toplevel verilog module is
top_module = gcdGCDUnit_rtl

# Verilog sources

srcs := \
	$(src)/gcdTestHarness_rtl.v \
	../dc/current/results/$(top_module).mapped.v \

# PDK path
pdk_dir := $(base_dir)/../FreePDK45/osu_soc/lib/files
cells_verilog = $(pdk_dir)/gscl45nm.v

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

VCS      := vcs -full64
VCS_OPTS := -notice -PP -line +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +v2k \
	-timescale=1ns/1ps -P ../dc/current/access.tab -debug \

#--------------------------------------------------------------------
# Build the simulator
#--------------------------------------------------------------------

vcs_sim = simv
$(vcs_sim) : Makefile $(srcs) $(vclib_srcs)
	$(VCS) $(VCS_OPTS) +incdir+$(src) -o $(vcs_sim) \
	+define+CLOCK_PERIOD=$(vcs_clock_period) \
	+define+functional=1 \
	+incdir+$(vclib) $(addprefix -v ,$(vclib_srcs)) \
	-v $(cells_verilog) $(srcs)

#--------------------------------------------------------------------
# Run
#--------------------------------------------------------------------

vpd = vcdplus.vpd
$(vpd): $(vcs_sim)
	./simv -ucli -do run.tcl +verbose=1
	date > timestamp

run: $(vpd)

#--------------------------------------------------------------------
# Default make target
#--------------------------------------------------------------------

.PHONY: run

all : $(vcs_sim) run

#--------------------------------------------------------------------
# Clean up
#--------------------------------------------------------------------

junk += simv* csrc *.vpd *.key DVE* .vcs* sdf* timestamp

clean :
	rm -rf $(junk) *~ \#* *.log *.cmd *.daidir
