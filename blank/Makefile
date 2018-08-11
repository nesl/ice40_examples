BLANK := blank

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(BLANK)

burn:
	$(MAKE) -C .. burn-$(BLANK)

clean:
	$(MAKE) -C .. $@
endif

VPATH += blank

BLANK_VSRC := $(addprefix $(BLANK)/,$(BLANK).v)
BLANK_SRC := $(BLANK_VSRC) $(addprefix $(BLANK)/,$(BLANK)_ct256.pcf)
SRC += $(BLANK_SRC)

.PHONY: $(BLANK)

blank: $(BUILD)/$(BLANK).bin

$(BLANK_SRC): $(BLANK)/Makefile
	touch $@

$(BUILD)/$(BLANK).blif: $(BLANK_VSRC)
