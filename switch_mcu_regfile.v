module switch_mcu_regfile (
    in_clk,
    in_rst,

    in_addr,
    in_wr,
    in_wdata,
    out_rdata
);

input wire in_clk, in_rst;

// Regsiter write address
input wire [4:0] in_addr;

// Regsiter write data
input wire [31:0] in_wdata;

// Register read data
output reg [31:0] out_rdata;

// Regsiter write enable
input wire in_wr;

// Regsiters File
reg [31:0] regfile [31:0];

integer i;

always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] <= 0;
        end
    end
    else begin
        if(in_wr) begin
            regfile[in_addr] <= in_wdata;
        end
        else begin
			regfile[in_addr] <= regfile[in_addr];
        end
    end
end

always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_rdata <= 32'h0000;
    end
    else begin
        if(!in_wr) begin
            out_rdata <= regfile[in_addr];
        end
        else begin
            out_rdata <= 32'h0000;
        end
    end
end

endmodule