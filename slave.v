module SPI_Slave(
    input wire sclk,
    input wire cs,
    input wire mosi,
    output wire miso,
    output reg [7:0] data_rx,
    input wire [7:0] data_tx
);

    reg [7:0] shift_in = 8'b0;
    reg [7:0] shift_out = 8'b0;
    reg [2:0] bit_cnt = 3'd7;

 
    always @(negedge cs) begin
        shift_out <= data_tx;
        bit_cnt <= 3'd7;
    end


    always @(posedge sclk) begin
        if (!cs) begin
            shift_in[bit_cnt] <= mosi;
        end
    end

  
    always @(negedge sclk) begin
        if (!cs) begin
            bit_cnt <= bit_cnt - 1;
            shift_out <= {shift_out[6:0], 1'b0}; 
        end
    end

    always @(posedge cs) begin
        data_rx <= shift_in;
    end

    assign miso = (cs == 0) ? shift_out[7] : 1'bz; 

endmodule
