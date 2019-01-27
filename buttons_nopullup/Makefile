BNOPULLUP := buttons_nopullup

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(BNOPULLUP)

burn:
	$(MAKE) -C .. burn-$(BNOPULLUP)

clean:
	$(MAKE) -C .. $@
endif

VPATH += $(BNOPULLUP)

BNOPULLUP_VSRC := $(BNOPULLUP)/$(BNOPULLUP).v
BNOPULLUP_SRC := $(BNOPULLUP_VSRC) $(BNOPULLUP)/$(BNOPULLUP)_ct256.pcf
SRC += $(BNOPULLUP_SRC)

.PHONY: $(BNOPULLUP)

$(BNOPULLUP): $(BUILD)/$(BNOPULLUP).bin

$(BNOPULLUP_SRC): $(BNOPULLUP)/Makefile

$(BUILD)/$(BNOPULLUP).blif: $(BNOPULLUP_VSRC)
