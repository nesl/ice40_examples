BBOUNCE := buttons_bounce

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(BBOUNCE)

burn:
	$(MAKE) -C .. burn-$(BBOUNCE)

clean:
	$(MAKE) -C .. $@
endif

VPATH += $(BBOUNCE)

BBOUNCE_VSRC := $(BBOUNCE)/$(BBOUNCE).v
BBOUNCE_SRC := $(BBOUNCE_VSRC) $(BBOUNCE)/$(BBOUNCE)_ct256.pcf
SRC += $(BBOUNCE_SRC)

.PHONY: $(BBOUNCE)

$(BBOUNCE): $(BUILD)/$(BBOUNCE).bin

$(BBOUNCE_SRC): $(BBOUNCE)/Makefile
	touch $@

$(BUILD)/$(BBOUNCE).blif: $(BBOUNCE_VSRC)
