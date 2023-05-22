module switch_mcu_dummy_sram (
    in_clk          ,
    in_rst          ,

    in_haddr        ,
    in_hwrite       ,
    in_hsize        ,
    in_hburst       ,
    in_hport        ,
    in_htrans       ,
    in_hmastlock    ,
    out_hready      ,
    out_hresp       ,
    out_hrdata      ,
);
// Global signals
input wire             in_clk          ;
input wire             in_rst          ;
// AHB Bus signals
input    wire [31:0]   in_haddr        ;
input    wire          in_hwrite       ;
input    wire [3:0]    in_hsize        ;
input    wire [3:0]    in_hport        ;
input    wire [2:0]    in_hburst       ;
input    wire [1:0]    in_htrans       ;
input    wire          in_hmastlock    ;
output   reg           out_hready      ;
output   reg           out_hresp       ;
output   reg  [31:0]   out_hrdata      ;

reg [31:0] sram [4095:0];

// Signals for debugging
wire [31:0] sram0 = sram[0];
wire [31:0] sram1 = sram[1];
wire [31:0] sram2 = sram[2];
wire [31:0] sram3 = sram[3];
wire [31:0] sram4 = sram[4];
wire [31:0] sram5 = sram[5];
wire [31:0] sram6 = sram[6];
wire [31:0] sram7 = sram[7];

integer i;

// Read
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_hrdata <= 0;
        out_hready <= 1;
        out_hresp <= 0;
    end else begin
        //NONSEQ && READ && SIZE == 2 && NO-BURST
        if((in_htrans == 1) && !in_hwrite && (in_hsize == 2) && (in_hburst == 0) && !in_hmastlock && (in_hport == 3)) begin
            out_hrdata <= sram[(in_haddr >> 2)];
            out_hready <= 1;
            out_hresp <= 0;
        end else begin
            out_hrdata <= 0;
            out_hready <= 1;
            out_hresp <= 0;
        end
    end
end

integer j;
initial begin
    #1;
    $readmemb("./data.hex", sram);  // 从文件中读取数据并赋值给memory数组
    // for(j = 0; j < 10 ;j = j + 1)
    // $display("Data[%d] = %h", j, sram1);
end

endmodule