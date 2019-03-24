/* Just pass through buttons to LEDs and RxD to TxD */

module passthrough (
    `ifdef BUTS
	    input [width - 1:0] but,
	    output [width - 1:0] led,
    `endif
    input uart_rx,
    output uart_tx
);

`ifdef BUTS
    parameter width = `LEDS > `BUTS ? `BUTS : `LEDS;
    assign but = led;
`endif
    assign uart_tx = uart_rx;

endmodule
