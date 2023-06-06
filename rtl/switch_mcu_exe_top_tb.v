module switch_mcu_exe_top_tb;

reg  mid_clk = 1;
reg  mid_rst = 0;

reg  mid_init_done;

wire [31:0]   mid_haddr        ;
wire          mid_hwrite       ;
wire [3:0]    mid_hsize        ;
wire [3:0]    mid_hport        ;
wire [2:0]    mid_hburst       ;
wire [1:0]    mid_htrans       ;
wire          mid_hmastlock    ;
wire          mid_hready       ;
wire          mid_hresp        ;
wire [31:0]   mid_hrdata       ;

switch_mcu_dummy_sram switch_mcu_dummy_sram_dut (
  .in_clk           (mid_clk ),
  .in_rst           (mid_rst ),
  .in_haddr         (mid_haddr ),
  .in_hwrite        (mid_hwrite ),
  .in_hsize         (mid_hsize ),
  .in_hburst        (mid_hburst ),
  .in_hport         (mid_hport ),
  .in_htrans        (mid_htrans ),
  .in_hmastlock     (mid_hmastlock ),
  .out_hready       (mid_hready ),
  .out_hresp        (mid_hresp ),
  .out_hrdata       (mid_hrdata )
);

switch_mcu_core_top switch_mcu_core_top_dut (
.in_clk             (mid_clk ),
.in_rst             (mid_rst ),
.in_init_done       (mid_init_done ),
.in_hready          (mid_hready ),
.in_hresp           (mid_hresp ),
.in_hrdata          (mid_hrdata ),
.out_haddr          (mid_haddr ),
.out_hwrite         (mid_hwrite ),
.out_hsize          (mid_hsize ),
.out_hport          (mid_hport ),
.out_hburst         (mid_hburst ),
.out_htrans         (mid_htrans ),
.out_hmastlock      (mid_hmastlock )
);

initial begin
  begin
    mid_rst = 0;
    mid_init_done = 0;
    #20;
    mid_rst = 1;
    #50;
    mid_init_done = 1;
    #10;
    #2400;
    $stop;
  end
end

always
  #5  mid_clk = ! mid_clk ;

initial
begin            
    $dumpfile("wave.vcd");
    $dumpvars(0, switch_mcu_exe_top_tb);
end
    
endmodule