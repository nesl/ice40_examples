/* Just pass through buttons to LEDs and RxD to TxD */

module passthrough (but, led, uart_tx, uart_rx);
    /* I/O */
    input [`LED-1:0] but;
    input uart_rx;
    output uart_tx;
    output [`LED-1:0] led;

    assign but = led;
    assign uart_tx = uart_rx;

endmodule
