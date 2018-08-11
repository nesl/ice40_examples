UART := uart_transmission

ifndef BUILD
.PHONY: all burn clean

all:
	$(MAKE) -C .. $(UART)

burn:
	$(MAKE) -C .. burn-uart

clean:
	$(MAKE) -C .. $@
endif

VPATH += $(UART)

UART_VSRC := $(addprefix $(UART)/,uart.v uart_trx.v)
UART_SRC := $(UART_VSRC) $(addprefix $(UART)/,uart_ct256.pcf uart_tq144.pcf)
SRC += $(UART_SRC)

.PHONY: $(UART)

$(UART): $(BUILD)/uart.bin

$(UART_SRC): $(UART)/Makefile
	touch $@

$(BUILD)/uart.blif: $(UART_VSRC)
