# Use := where you can, as it only gets evaluated once
BUILD     := build
# ?= allows the user to pass in a device on the command line
DEVICE   ?= 8k
ifeq (8k,$(DEVICE))
FOOTPRINT := ct256
else
FOOTPRINT := tq144
endif

ifdef VERBOSE
Q :=
else
Q :=1
endif

# Necessary so VPATH doesn't get reinterpreted
VPATH :=

MODULES := uart_transmission blank blinky buttons_bounce buttons_debounce buttons_nopullup fsm_simple

# SRC holds all source files
SRC :=

.PHONY: all clean burn-% FORCE

all:

$(BUILD):
	mkdir -p $(BUILD)

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
	yosys $(and $(Q),-q) -p "synth_ice40 -top $* -blif $@" $^

# .PHONY causes targets to be rebuilt every make, and built even if there is an up-to-date file
# Depending on a .PHONY target will cause the rule to be run every time
# but make will pay attention to timestamps and not run further dependencies if the target doesn't get updated
FORCE:

# We are going to exploit that here to make sure we rebuild if the user changes the value of DEVICE
# We compare the current value of the variable to what is in env
# If they are different, we update the file
# If they are the same we don't
# Anything which depends on $(BUILD)/DEVICE.var will only update if DEVICE changes
$(BUILD)/%.var: FORCE
	echo $($*) | cmp - $@ || echo $($*) > $@

# Keep .var file around even though they are intermediate targets
.PRECIOUS: $(BUILD)/%.var

$(BUILD)/%: %
	cp -f $< $@

# Note that yosys does not run if you only change DEVICE, just things from here down
%.asc: %.blif %_$(FOOTPRINT).pcf $(BUILD)/DEVICE.var $(BUILD)/FOOTPRINT.var
	arachne-pnr $(and $(Q),-q) -d $(DEVICE) -P $(FOOTPRINT) -o $@ -p $*_$(FOOTPRINT).pcf $<

%.bin: %.asc
	icepack $< $@

burn-%: $(BUILD)/%.bin
	iceprog $<

clean:
	rm -rf $(BUILD)

include $(addsuffix /Makefile,$(MODULES))

# Because our sources/pinmaps depend on the makefile
# all targets will get rebuilt every time the makefile changes
$(SRC): Makefile
	touch $@
