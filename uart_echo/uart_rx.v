// 8N1 UART Module, transmit only

module uart_rx_8n1 (
    input  wire     clk,       // input clock
    input  wire     rx,        // rx wire
    input  wire     recvdata,  // allow any bytes to come in
    output reg[7:0] rxbyte,    // incoming byte as output
    output reg      rxdone     // byte received
//  ,  output wire[1:0] stateOut
    );

    /* Parameters */
    parameter STATE_IDLE  = 2'd0;
    parameter STATE_RXING = 2'd1;
    parameter STATE_STOPRX= 2'd2;
    parameter STATE_RXDONE= 2'd3;

    /* State variables */
    reg[1:0] state=STATE_IDLE;
    reg[7:0] buf_rx=8'b0;
    reg[4:0] bits_received=5'b0;

    //assign stateOut=state;

    /* always */
    always @ (posedge clk) begin

        case (state)

        STATE_IDLE: begin
            rxdone <= 1'b0;
            if (recvdata) begin
               // check if startbit was sent
               if (1'b0 == rx) begin
                  state <= STATE_RXING;
                  // initialise what is to come
                  rxbyte <= 8'b0;
                  bits_received <= 5'b0;
               end
            end
        end

        STATE_RXING: begin
            if (bits_received < 5'd8) begin
               // received a data bit
	       buf_rx = buf_rx>>1;
               buf_rx[7] = rx;
               //buf_rx = {rx,buf_rx[7:1]};
               bits_received <= bits_received + 1;
            end else begin
               // received the stop bit
               state <= STATE_RXDONE;
               rxbyte <= buf_rx;
               //rxbyte <= 8'd69;
            end
            //rxbyte <= "0"+ bits_received;
        end

        STATE_RXDONE: begin
            state <= STATE_IDLE;
            rxdone <= 1'b1;
        end

	default: begin
            state <= STATE_IDLE;
        end

        endcase

    end // always

endmodule
