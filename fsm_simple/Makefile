FSM := fsm_simple

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(FSM)

burn:
	$(MAKE) -C .. burn-fsm

clean:
	$(MAKE) -C .. $@
endif

VPATH += $(FSM)

FSM_VSRC := $(addprefix $(FSM)/,fsm.v button.v)
FSM_SRC := $(FSM_VSRC) $(FSM)/fsm_ct256.pcf
SRC += $(FSM_SRC)

.PHONY: $(FSM)

$(FSM): $(BUILD)/fsm.bin

$(FSM_SRC): $(FSM)/Makefile
	touch $@

$(BUILD)/fsm.blif: $(FSM_VSRC)
