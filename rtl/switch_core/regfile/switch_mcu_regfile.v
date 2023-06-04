module switch_mcu_regfile (
    in_clk                      ,
    in_rst                      ,

    in_gpr_waddr                ,
    in_gpr_wen                  ,
    in_gpr_wdata                ,

    in_gpr_raddr_1              ,
    in_gpr_ren_1                ,
    out_gpr_rdata_1             ,

    in_gpr_raddr_2              ,
    in_gpr_ren_2                ,
    out_gpr_rdata_2             ,
);

input wire in_clk, in_rst;

/* WRITE PORT */
// Regsiter write address
input wire [4:0] in_gpr_waddr;
// Regsiter write data
input wire [31:0] in_gpr_wdata;
// Regsiter write enable
input wire in_gpr_wen;

/* READ PORT 1 */
// Regsiter read address
input wire [4:0] in_gpr_raddr_1;
// Regsiter read data
output reg [31:0] out_gpr_rdata_1;
// Regsiter read enable
input wire in_gpr_ren_1;

/* READ PORT 2 */
// Regsiter read address
input wire [4:0] in_gpr_raddr_2;
// Regsiter read data
output reg [31:0] out_gpr_rdata_2;
// Regsiter read enable
input wire in_gpr_ren_2;

// Regsiters File
reg [31:0] regfile [31:0];

// Singals to debug
wire [31:0] regfile0 = regfile[0];
wire [31:0] regfile1 = regfile[1];
wire [31:0] regfile2 = regfile[2];
wire [31:0] regfile3 = regfile[3];
wire [31:0] regfile4 = regfile[4];

integer i;

// WRITE PORT
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] <= 0;
        end
    end
    else begin
        if(in_gpr_wen) begin
            if(in_gpr_waddr == 0) // Prohibit wrting reg0
                regfile[in_gpr_waddr] <= regfile[in_gpr_waddr];
            else
                regfile[in_gpr_waddr] <= in_gpr_wdata;
        end
        else begin
			regfile[in_gpr_waddr] <= regfile[in_gpr_waddr];
        end
    end
end

// READ PORT 1
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_gpr_rdata_1 <= 32'h0000;
    end
    else begin
        if(in_gpr_ren_1) begin
            out_gpr_rdata_1 <= regfile[in_gpr_raddr_1];
        end
        else begin
            out_gpr_rdata_1 <= 32'h0000;
        end
    end
end

// READ PORT 2
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_gpr_rdata_2 <= 32'h0000;
    end
    else begin
        if(in_gpr_ren_2) begin
            out_gpr_rdata_2 <= regfile[in_gpr_raddr_2];
        end
        else begin
            out_gpr_rdata_2 <= 32'h0000;
        end
    end
end

endmodule