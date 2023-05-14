module switch_mcu_regfile_tb;

  // Parameters

  // Ports
  reg  in_clk = 0;
  reg   in_rst = 0;
  reg [4:0] in_addr;
  reg [31:0] in_wdata;
  wire [31:0] out_rdata;
  reg  in_wr = 0;

  switch_mcu_regfile switch_mcu_regfile_dut (
    .in_clk (in_clk ),
    . in_rst ( in_rst ),
    .in_addr (in_addr ),
    .in_wdata (in_wdata ),
    .out_rdata (out_rdata ),
    .in_wr  ( in_wr)
  );

  initial begin
        in_rst = 0;
        #15;
        in_rst = 1;
        #10;
        in_addr = 5'd1;
        in_wr = 1'b1;
        in_wdata = 32'h1234;
        #10;
        in_addr = 5'd2;
        in_wr = 1'b1;
        in_wdata = 32'h2345;
        #10;
        in_addr = 5'd2;
        in_wr = 1'b0;
        in_wdata = 32'h0000;
        #30;
	$stop;
    end

  always
    #5  in_clk = ! in_clk ;


  initial
    begin            
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, switch_mcu_regfile_tb);    //tb模块名称
    end
    
endmodule
