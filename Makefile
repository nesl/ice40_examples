# Use := where you can, as it only gets evaluated once
BUILD := build

# Load previous values of variables
VARS := $(foreach VAR,$(wildcard $(BUILD)/*.var),$(basename $(notdir $(VARIABLE))))
$(foreach VAR,$(VARS),$(eval $(VAR) ?= $(shell cat $(BUILD)/$(VAR).var)))

BOARD ?= Lattice/ICE40HX1K-STICK-EVN
include boards/$(BOARD)/cfg
FAMILY := $(strip $(subst lp,,$(subst hx,, $(subst up,,$(DEVICE)))))
# List of variables set by the board cfg
# We don't just use VARS since this could be the first run,
# so some of these variables may not have a .var file
BOARD_VARS := DEVICE PACKAGE LEDS BUTS CLOCK
BOARD_DEFINES := $(foreach VAR,$(BOARD_VARS),$(and $($(VAR)),-D$(VAR)=$($(VAR))))

ifdef VERBOSE
Q :=
else
Q :=1
endif

PNR ?= arachne-pnr
SYNTH ?= yosys
FLASH ?= iceprog

# Necessary so VPATH doesn't get reinterpreted
VPATH :=
MODULES := uart blank blinky passthrough

# SRC holds all source files
SRC :=

.PHONY: all clean burn-% time-% test-% cov-% FORCE

all:

$(BUILD):
	mkdir -p $@

# First pattern rule creates a .blif from a .v
# We also have an order-only prerequisite on the build dir
# This means it must be created first, but make doesn't care if it's out-of-date
# The timestamp of a directory changes whenever a file within it is created
# So if we didn't ignore it, we would build everything three times
# Quick introduction to make variables:
# $@ current target, what goes to the left of a make rule
# $< First dependency
# $^ all non-order-only dependencies
# $* the stem of an implicit rule -- what % matches in %.blif
$(BUILD)/%.blif: %.v | $(BUILD)
	$(SYNTH) $(and $(Q),-q) -p "read_verilog -noautowire $(BOARD_DEFINES) $^; synth_ice40 -top $* -blif $@"

# .PHONY causes targets to be rebuilt every make, and built even if there is an up-to-date file
# Depending on a .PHONY target will cause the rule to be run every time
# but make will pay attention to timestamps and not run further dependencies if the target doesn't get updated
FORCE:

# We are going to exploit that here to make sure we rebuild if the user changes the value of DEVICE
# We compare the current value of the variable to what is in env
# If they are different, we update the file
# If they are the same we don't
# Anything which depends on $(BUILD)/DEVICE.var will only update if DEVICE changes
$(BUILD)/%.var: FORCE | $(BUILD)
	@echo "$($*)" | cmp -s - "$@" || echo "$($*)" > $@

# Keep .var file around even though they are intermediate targets
.PRECIOUS: $(BUILD)/%.var

$(BUILD)/%: %
	ln -f $< $@

# Note that yosys does not run if you only change DEVICE, just things from here down
%.asc: %.blif boards/$(BOARD)/pcf $(BUILD)/FAMILY.var $(BUILD)/PACKAGE.var $(BUILD)/BOARD.var $(BUILD)/PNR.var
	$(PNR) $(and $(Q),-q) -d $(FAMILY) -P $(PACKAGE) -p boards/$(BOARD)/pcf -o $@ $<

%.bin: %.asc
	icepack $< $@

burn-%: $(BUILD)/%.bin $(BUILD)/FLASH.var
	$(FLASH) $<

time-%: $(BUILD)/%.asc boards/$(BOARD)/pcf $(BUILD)/DEVICE.var $(BUILD)/PACKAGE.var $(BUILD)/BOARD.var
	icetime -t -d $(DEVICE) -P $(PACKAGE) -p boards/$(BOARD)/pcf $<

clean:
	rm -rf $(BUILD)

include $(addsuffix /Makefile,$(MODULES))

# The following snippet Copyright 2003-2019 by Wilson Snyder, 2019 Sean Anderson
# This program is free software; you can redistribute it and/or modify
# it under the terms of either the GNU Lesser General Public License Version 3
# or the Perl Artistic License Version 2.0.

VERILATOR ?= verilator
VERILATOR_COVERAGE ?= verilator_coverage
# Generate C++ in executable form
VERILATOR_FLAGS += -cc --exe
# Optimize
VERILATOR_FLAGS += -O2 -x-assign 0
# Warn abount lint issues; may not want this on less solid designs
VERILATOR_FLAGS += -Wall
# Make waveforms
VERILATOR_FLAGS += --trace
# Check SystemVerilog assertions
VERILATOR_FLAGS += --assert
# Generate coverage analysis
VERILATOR_FLAGS += --coverage
# end snippet

# Similar to BOARD_DEFINES, but we need to be careful to remove non-c-friendly characters
# signed numbers are NOT supported
sanitize = $(lastword $(subst 'h,' 0x,$(subst 'd,' ,$(subst _,,$1))))
export USER_CPPFLAGS := $(foreach VAR,$(BOARD_VARS),$(and $($(VAR)),-D$(VAR)=$(call sanitize,$($(VAR)))))

$(BUILD)/test-%:
	mkdir -p $@

test-%: | $(BUILD)/test-%
	$(VERILATOR) $(VERILATOR_FLAGS) $$(echo "$(BOARD_DEFINES)") -Mdir $(BUILD)/test-$* --prefix $* $^
	$(MAKE) -C $(BUILD)/test-$* -f $*.mk
	$(BUILD)/test-$*/$* +trace

cov-%: test-%
	$(VERILATOR_COVERAGE) --annotate $(BUILD)/test-$*/logs/annotated $(BUILD)/test-$*/logs/coverage.dat

# Because our sources/pinmaps depend on the makefile
# all targets will get rebuilt every time the makefile changes
# Additionally, we need to depend on BOARD
# (and SYNTH/VERILATOR* since this is the only place to put it)
$(SRC): Makefile $(BUILD)/BOARD.var $(BUILD)/SYNTH.var $(BUILD)/VERILATOR.var $(BUILD)/VERILATOR_COVERAGE.var
	@touch $@
