module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); 
    
    wire [3:0]q0;
    wire [3:0]q1;
    wire [3:0]q2;
    
    assign c_enable[0]=4'd1;
    assign c_enable[1]=(q0==4'd9);
    assign c_enable[2]=(q0==4'd9 && q1==4'd9);

    bcdcount counter0 (clk, reset, c_enable[0],q0);
    bcdcount counter1 (clk, reset, c_enable[1],q1);
    bcdcount counter2 (clk, reset, c_enable[2],q2);
    
    assign OneHertz=(q0==4'd9 && q1==4'd9 && q2==4'd9);
   
endmodule
