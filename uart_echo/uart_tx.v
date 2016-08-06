// 8N1 UART Module, transmit only

module uart_tx_8n1 (
    input  wire      clk,      // input clock
    output wire      tx,       // tx wire
    input  wire      senddata, // trigger tx
    input  wire[7:0] txbyte,   // outgoing byte
    output reg       txdone    // outgoing byte sent
    );

    /* Parameters */
    parameter STATE_IDLE   = 2'd0;
    parameter STATE_STARTTX= 2'd1;
    parameter STATE_TXING  = 2'd2;
    parameter STATE_TXDONE = 2'd3;

    /* State variables */
    reg[1:0] state= STATE_IDLE;
    reg[7:0] buf_tx=8'b0;
    reg[7:0] bits_sent=5'b0;
    reg txbit=1'b1;

    /* Wiring */
    assign tx=txbit;

    /* always */
    always @ (posedge clk) begin

        case (state) 

        STATE_IDLE: begin
            // start sending?
            if (senddata == 1) begin
                state <= STATE_STARTTX;
                buf_tx <= txbyte;
                txdone <= 1'b0;
            end else if (state == STATE_IDLE) begin
                // idle at high
                txbit <= 1'b1;
                txdone <= 1'b0;
            end
        end

        STATE_STARTTX: begin
            txbit <= 1'b0;
            state <= STATE_TXING;
        end

	STATE_TXING: begin
            if (bits_sent < 5'd8) begin
                txbit <= buf_tx[0];
                buf_tx <= buf_tx>>1;
                bits_sent = bits_sent + 1;
            end else begin
                // send stop bit (high)
                txbit <= 1'b1;
                bits_sent <= 5'b0;
                state <= STATE_TXDONE;
            end
	end

	STATE_TXDONE: begin
             txdone <= 1'b1;
             state <= STATE_IDLE;
        end

	default: begin
	    state <= STATE_IDLE;
	end

        endcase
   end

endmodule
