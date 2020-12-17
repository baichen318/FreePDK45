# Author: baichen318@gmail.com

default: all

log_dir ?= logs

all: mips.v
	mkdir -p $(log_dir)
	dc_shell-t -f compile_dc.tcl | tee -i $(log_dir)/dc.log

.PHONY: clean
clean:
	rm -rf command.log default.svf reports WORK $(log_dir)
