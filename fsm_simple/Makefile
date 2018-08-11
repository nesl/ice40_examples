FSM := fsm_simple

VPATH += $(FSM)

FSM_VSRC := $(addprefix $(FSM)/,fsm.v button.v)
FSM_SRC := $(FSM_VSRC) $(FSM)/fsm_ct256.pcf
SRC += $(FSM_SRC)

.PHONY: $(FSM)

$(FSM): $(BUILD)/fsm.bin

$(FSM_SRC): $(FSM)/Makefile
	touch $@

$(BUILD)/fsm.blif: $(FSM_VSRC)
