# Author: baichen318@gmail.com

default: all

long_name ?= chipyard.TestHarness.SmallBoomConfig

all: src/$(long_name).top.v \
	 src/$(long_name).top.mems.v \
	 src/$(long_name).harness.v \
	 src/$(long_name).harness.mems.v \
	 src/EICG_wrapper.v \
	 src/IOCell.v \
	 src/plusarg_reader.v \
	 src/SimDRAM.v \
	 src/SimSerial.v \
	 src/SimUART.v \
	 src/TestDriver.v
	dc_shell-t -f compile_dc.tcl

.PHONY: clean
clean:
	rm -rf command.log default.svf reports WORK filenames.log
