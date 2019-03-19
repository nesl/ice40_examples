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
M_SRC := $(M_VSRC) $(addprefix $(DIR),$(M_SRC))
SRC += $(M_SRC)

.PHONY: $(MODULE)
$(MODULE): $(BUILD)/$(MODULE).bin

$(M_SRC): $(DIR)Makefile $(lastword $(MAKEFILE_LIST))

$(BUILD)/$(MODULE).blif: $(M_VSRC)

ifdef BUILD
all: $(MODULE)
endif
