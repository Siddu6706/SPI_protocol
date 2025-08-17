module SPI_Test;

    reg clk = 0;
    reg rst = 0;
    reg send_data = 0;
    reg [7:0] master_data_in = 8'hA5; 
    wire mosi;
    wire sclk;
    wire cs;
    wire miso;
    wire [7:0] master_data_out;
    wire done;

    wire [7:0] slave_data_rx;
    reg [7:0] slave_data_tx = 8'hA6;

 
    always #10 clk = ~clk;

  
    SPI_Master master (
        .clk(clk),
        .rst(rst),
        .send_data(send_data),
        .data_in(master_data_in),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .data_out(master_data_out),
        .done(done),
        .miso(miso)
    );

    
    SPI_Slave slave (
        .sclk(sclk),
        .cs(cs),
        .mosi(mosi),
        .miso(miso),
        .data_rx(slave_data_rx),
        .data_tx(slave_data_tx)
    );

    initial begin
        $display("Starting SPI Master-Slave testbench...");

        rst = 1;
        send_data = 0;
        #50 rst = 0;

        #20;
        send_data = 1;    
        #20 send_data = 0;

        
        wait(done);

        $display("Master sent: %h", master_data_in);
        $display("Master received: %h", master_data_out);
        $display("Slave received: %h", slave_data_rx);
        $display("Slave sent: %h", slave_data_tx);

        #100 $stop;
    end

endmodule
