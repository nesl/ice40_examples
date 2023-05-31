/* Top level module for keypad + UART demo */
module top (
    // input hardware clock (12 MHz)
    input wire hwclk,
    // all LEDs
    output wire led1,
    output wire led2,
    output wire led3,
    output wire led4,
    // UART lines
    output wire tx, 
    input  wire rx
    );

    // UART registers
    wire [7:0] uart_rxbyte;
    reg  [7:0] uart_txbyte=8'b0;
    reg uart_send    = 1'b1; // do not send anything by default
    reg uart_receive = 1'b1; // listen
    wire uart_txed;
    wire uart_rxed;

    // LED register
    reg ledval1 = 0;
    reg ledval2 = 0;
    reg ledval3 = 0;
    reg ledval4 = 0;

    wire clk_9600; // takes the clock triggeres generated in read

   // wire[1:0] state;

/*
    assign led3 = ~state[1];
    assign led4 = ~state[0];
*/

    // UART receiver module designed for
    // 8 bits, no parity, 1 stop bit. 
    uart_rx_8n1 receiver (
        .hwclk (hwclk),
        .clk_9600 (clk_9600),     // 9600 baud rate clock, triggered by reads from host
        .rx (rx),                 // input UART rx pin
        .recvdata (uart_receive), // allow any incoming bytes
        .rxbyte (uart_rxbyte),    // byte received
        .rxdone (uart_rxed)      // input: rx is finished
    );

    // UART transmitter module designed for
    // 8 bits, no parity, 1 stop bit. 
    uart_tx_8n1 transmitter (
        .clk (clk_9600),       // 9600 baud rate clock
        .tx (tx),              // output UART tx pin
        //.senddata (uart_rxed), // trigger a UART transmit on baud clock
        //.senddata (1'b1), // trigger a UART transmit on baud clock
        .senddata (uart_send), // trigger a UART transmit on baud clock
        .txbyte (uart_txbyte), // byte to be transmitted
        //.txbyte (8'd70), // byte to be transmitted
        .txdone (uart_txed)    // input: tx is finished
    );




    // Wiring
    //assign led1=ledval1;
    assign led2=ledval2;
    assign led3=ledval3;
    assign led4=ledval4;

    always @(posedge clk_9600) begin
        if(uart_rxed) begin
            uart_txbyte <= uart_rxbyte;
            uart_send <= 1;
            ledval4 <= ~ledval4;
        end
        else begin
            uart_send <= 0;
        end

        if(uart_txed) begin
            ledval3 <= ~ledval3;
        end

        if(rx) begin
            ledval2 <= ~ledval2;
        end
    end



endmodule
