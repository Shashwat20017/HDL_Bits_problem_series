module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
); 
    
    wire ross0, ross1, romm0, romm1, rohh0, rohh1;
    wire ena_s0, ena_s1, ena_m0, ena_m1, ena_h0, ena_h1;
    
    // --- ENABLE CHAIN LOGIC ---
    assign ena_s0 = ena;                        
    assign ena_s1 = ross0; 
    assign ena_m0 = ross1; 
    assign ena_m1 = romm0; 
    assign ena_h0 = romm1; 
    assign ena_h1 = rohh0; 

    // --- SECONDS & MINUTES ---
    bcd_count s0_count (clk, reset, ena_s0, 4'd9, 4'd0, 4'd0, ross0, ss[3:0]);
    bcd_count s1_count (clk, reset, ena_s1, 4'd5, 4'd0, 4'd0, ross1, ss[7:4]);
    bcd_count m0_count (clk, reset, ena_m0, 4'd9, 4'd0, 4'd0, romm0, mm[3:0]);
    bcd_count m1_count (clk, reset, ena_m1, 4'd5, 4'd0, 4'd0, romm1, mm[7:4]);
    
    // --- HOURS LOGIC ("Dynamic Limit" Concept) ---
    wire [3:0] limit_h0    = (hh[7:4] == 4'd1) ? 4'd2 : 4'd9; 
    wire [3:0] roll_val_h0 = (hh[7:4] == 4'd1) ? 4'd1 : 4'd0; 
    
    bcd_count h0_count (clk, reset, ena_h0, limit_h0, 4'd2, roll_val_h0, rohh0, hh[3:0]);
    bcd_count h1_count (clk, reset, ena_h1, 4'd1, 4'd1, 4'd0, rohh1, hh[7:4]);
    
    // --- AM/PM LOGIC ---
    reg pm_reg;
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0; 
        end else if (hh == 8'h11 && mm == 8'h59 && ss == 8'h59 && ena) begin
            pm_reg <= ~pm_reg; 
        end
    end
    assign pm = pm_reg;
        
endmodule


// ==========================================
// STANDARD BCD COUNTER MODULE
// ==========================================
module bcd_count (
    input clk,
    input reset,      
    input ena,  
    input [3:0] lm,        
    input [3:0] reset_val, 
    input [3:0] roll_val,  
    output ro,             
    output reg [3:0] q
);
    assign ro = ena && (q == lm);

    always @(posedge clk) begin
        if (reset) begin
            q <= reset_val;
        end
        else if (ena) begin
            if (q == lm) begin
                q <= roll_val;
            end
            else begin
                q <= q + 1'b1;
            end
        end
    end       
endmodule