# Author: baichen318@gmail.com

default: all

base_dir := $(shell pwd)/..
src := $(base_dir)/src

# User definitions

srcs := \
	$(src)/gcdGCDUnit_rtl.v \
	$(src)/gcdGCDUnitCtrl.v \
	$(src)/gcdGCDUnitDpath.v \

top_module := gcdGCDUnit_rtl
testharness := gcdTestHarness_rtl
top_inst := gcdGCDUnit_rtl

# Define variables

include $(base_dir)/Makefrag

dc_exec := dc_shell-xg-t
scripts_dir := scripts
scripts := \
	$(scripts_dir)/dc.tcl \
	$(scripts_dir)/dc_setup.tcl \
	$(scripts_dir)/dc_setup_filenames.tcl \
	$(scripts_dir)/common_setup.tcl \
	$(scripts_dir)/constraints.tcl \
	$(scripts_dir)/find_regs.tcl \

vclib := $(src)/vclib
timestamp := $(shell date +%Y-%m-%d-%H-%M)
build_dir := build-$(timestamp)
dc_timestamp := $(build_dir)/timestamp
reports_dir := reports
results_dir := results
log_dir := logs
current := current
make_generated_vars_tcl := make_generated_vars.tcl
pdk_dir := $(base_dir)/../FreePDK45/osu_soc/lib/files

# Macros
vars = \
	set DESIGN_NAME					"$(top_module)";\n \
	set PDK_DIR						"$(pdk_dir)";\n \
	set STRIP_PATH					"$(testharness)/$(top_inst)";\n \
	set ADDITIONAL_SEARCH_PATH		"$(vclib) $(pdk_dir)";\n \
	set RTL_SOURCE_FILES			"$(srcs)";\n \
	set REPORTS_DIR					"$(reports_dir)";\n \
	set RESULTS_DIR					"$(results_dir)";\n \
	set CLOCK_PERIOD				"$(dc_clock_period)";\n \

# Compilation steps

define setup
	$(warning test)
	rm -rf $(current) 
	mkdir -p $(build_dir)
	mkdir -p $(build_dir)/$(log_dir)
	ln -s $(build_dir) $(current)
	cp -f $(scripts_dir)/* $(build_dir)
	/bin/echo -e '$(vars)' > $(current)/$(make_generated_vars_tcl)
endef

$(dc_timestamp): Makefile $(srcs) $(scripts)
	$(setup)

dc: $(dc_timestamp)
	cd $(current) && date > timestamp;
	cd $(current) && $(dc_exec) -f dc.tcl | tee -i $(log_dir)/dc.log

all: dc

# Clean up

.PHONY: clean
clean:
	rm -rf $(current) build-*
