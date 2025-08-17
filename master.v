module SPI_Master (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire send_data,
    input wire miso,          
    output reg mosi,
    output reg sclk,
    output reg cs,
    output reg [7:0] data_out,
    output reg done
);

    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;
    reg [7:0] recv_reg;
    reg sending;
    reg clk_div;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mosi <= 0;
            sclk <= 0;
            cs <= 1;
            shift_reg <= 0;
            recv_reg <= 0;
            bit_cnt <= 0;
            done <= 0;
            sending <= 0;
            clk_div <= 0;
        end else begin
            done <= 0;
            clk_div <= ~clk_div;

            if (send_data && !sending) begin
                sending <= 1;
                cs <= 0;
                shift_reg <= data_in;
                bit_cnt <=3'd7;
                sclk <= 0;
            end else if (sending && clk_div) begin
                sclk <= ~sclk;

                if (sclk == 0) begin
                    mosi <= shift_reg[bit_cnt];
                end else begin
                    recv_reg[bit_cnt] <= miso;
                    if (bit_cnt == 0) begin
                        sending <= 0;
                        cs <= 1;
                        done <= 1;
                        data_out <= recv_reg;
                    end else begin
                        bit_cnt <= bit_cnt-1;
                    end
                end
            end
        end
    end
endmodule
