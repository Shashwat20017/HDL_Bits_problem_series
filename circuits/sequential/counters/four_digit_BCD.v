/*Build a 4-digit BCD (binary-coded decimal) counter. Each decimal digit is encoded using 4 bits:
 q[3:0] is the ones digit, q[7:4] is the tens digit, etc. For digits [3:1], 
 also output an enable signal indicating when each of the upper three 
 digits should be incremented.

You may want to instantiate or modify some one-digit decade counters.*/

module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    assign ena[1]=(q[3:0]==4'd9);
    assign ena[2]=(q[3:0]==4'd9 && q[7:4]==4'd9);
    assign ena[3]=(q[3:0]==4'd9 && q[7:4]==4'd9 && q[11:8]==4'd9);
    
    bcd_counter counter0 (clk,reset,   1'b1,q[3:0]);
    bcd_counter counter1 (clk,reset, ena[1],q[7:4]);
    bcd_counter counter2 (clk,reset, ena[2],q[11:8]);
    bcd_counter counter3 (clk,reset, ena[3],q[15:12]);
    
    
endmodule    

module bcd_counter (
    input clk,
    input reset,      // Synchronous active-high reset
    input ena,   
    output [3:0] q);
    
    always@(posedge clk) begin
        if(reset)
            q<=0;
        else if(ena) begin
            if(q>=9)
                q<=4'd0;
            else
                q<=q+1;
        end
    end
        
endmodule