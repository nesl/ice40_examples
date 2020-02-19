// Blink an LED provided an input clock

/* module */
module blinky (hwclk, led);
    input hwclk;
    output reg [`LEDS - 1:0] led;

    /*
     * led[`LEDS-1] should blink at 1hz
     * the *switching* speed should be 2 hz
     */
    parameter cycles = `CLOCK / (2 * `LEDS);
    reg [32:0] counter = 32'b0;

    always @ (posedge hwclk) begin
	if (counter == cycles) begin
		led <= led + 1;
		counter <= 32'b0;
	end else
		counter <= counter + 1;
    end

endmodule
