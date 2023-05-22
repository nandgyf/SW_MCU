module cycle_cnt (
    in_clk,
    in_rst,
    in_init_done,
    out_cycle_cnt,
);

input   wire          in_clk        ;
input   wire          in_rst        ;
input   wire          in_init_done  ;      
output  reg  [3:0]    out_cycle_cnt ;

// Counter logic
always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst | !in_init_done)
    out_cycle_cnt <= 0;
    else if(out_cycle_cnt == 2)
        out_cycle_cnt <= 0;
    else
        out_cycle_cnt <= out_cycle_cnt + 1;
  end
    
endmodule