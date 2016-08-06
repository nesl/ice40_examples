module uart_clock_top (
    // input hardware clock (12 MHz)
    input wire hwclk,
    // all LEDs
    output wire led1,
    output wire led2,
    output wire led3,
    output wire led4
);

    parameter period_1 = 32'd6000000;
    wire clk_1;
    reg  clk_1_reset=0;
    uart_clock clock_1 (
        .hwclk(hwclk),
        .reset(clk_1_reset),
        .period(period_1),
        .clk(clk_1),
//        .led(led3)
    );
    assign led4 = ~clk_1;

endmodule
