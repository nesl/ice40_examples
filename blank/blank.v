// Blink an LED provided an input clock
/* module */
module blank (hwclk, led);
    /* I/O */
    input hwclk;
    output [`LEDS - 1:0] led;

endmodule
