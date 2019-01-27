BDEBOUNCE := buttons_debounce

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(BDEBOUNCE)

burn:
	$(MAKE) -C .. burn-$(BDEBOUNCE)

clean:
	$(MAKE) -C .. $@
endif

VPATH += $(BDEBOUNCE)

BDEBOUNCE_VSRC := $(BDEBOUNCE)/$(BDEBOUNCE).v
BDEBOUNCE_SRC := $(BDEBOUNCE_VSRC) $(BDEBOUNCE)/$(BDEBOUNCE)_ct256.pcf
SRC += $(BDEBOUNCE_SRC)

.PHONY: $(BDEBOUNCE)

$(BDEBOUNCE): $(BUILD)/$(BDEBOUNCE).bin

$(BDEBOUNCE_SRC): $(BDEBOUNCE)/Makefile

$(BUILD)/$(BDEBOUNCE).blif: $(BDEBOUNCE_VSRC)
