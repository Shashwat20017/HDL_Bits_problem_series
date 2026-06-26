module count4 (
    input wire clk,
    input wire enable,
    input wire load,
    input wire [3:0] d,
    output reg [3:0] Q
);

    always @(posedge clk) begin
        if (load) begin
            // Load has the highest priority
            Q <= d;
        end 
        else if (enable) begin
            // Increment only if enabled (and not loading)
            Q <= Q + 1'b1;
        end
        // If neither 'load' nor 'enable' is active, Q implicitly holds its value
    end

endmodule

module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); 
    
    assign c_load=reset || (enable && Q>=12);
    assign c_d=4'b0001;
    assign c_enable=enable;             
    
    count4 range_counter (clk,c_enable,c_load,c_d,Q);
   
endmodule