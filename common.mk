# Really ugly, but make can't decrement so we get this...
getincluder = $(word $(words $(wordlist 2,$(words $1),$1)),$1)
DIR := $(dir $(call getincluder,$(MAKEFILE_LIST)))

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(MODULE)

burn:
	$(MAKE) -C .. burn-$(MODULE)

clean:
	$(MAKE) -C .. $@
endif

VPATH += $(DIR)

M_VSRC := $(addprefix $(DIR),$(M_VSRC))
M_CSRC := $(addprefix $(DIR),$(M_CSRC))
SRC += $(M_VSRC) $(M_CSRC)

.PHONY: $(MODULE)
$(MODULE): $(BUILD)/$(MODULE).bin

$(BUILD)/$(MODULE).blif: $(M_VSRC)

test-$(MODULE): $(M_VSRC) $(M_CSRC)

ifdef BUILD
all: $(MODULE)
endif
