/* Top level module for keypad + UART demo */
module uart_clock (
    input wire hwclk,    // input hardware clock (12 MHz)
    input wire reset,    // reset hardware clock to 0
    input wire [31:0] period,
    output wire clk      // clock of reduced speed
    //, output wire led
    );

    reg [31:0] cntr = 32'b0;

    reg clkval=1'b0;

    initial begin
	clkval=1'b0;
    end

/*
    // Breaks it - as if ever active
    always @ (posedge reset) begin
        clkval=1'b0;
        cntr <= 32'b0;
    end
*/

    always @ (posedge hwclk) begin
        cntr <= cntr + 1;
        if (cntr == period) begin
            clkval <= ~clkval;
            cntr <= 32'b0;
        end
    end

    assign clk = clkval;
    //assign led = clkval;

endmodule
