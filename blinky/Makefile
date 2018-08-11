ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. blinky

burn:
	$(MAKE) -C .. burn-blinky

clean:
	$(MAKE) -C .. $@
endif

VPATH += blinky

BLINKY_VSRC := blinky/blinky.v
BLINKY_SRC := $(BLINKY_VSRC) blinky/blinky_ct256.pcf
SRC += $(BLINKY_SRC)

.PHONY: blinky

blinky: $(BUILD)/blinky.bin

$(BLINKY_SRC): blinky/Makefile
	touch $@

$(BUILD)/blinky.blif: $(BLINKY_VSRC)
