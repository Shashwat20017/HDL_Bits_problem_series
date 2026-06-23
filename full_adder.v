module full_adder(input a,b,cin , output reg sum, reg cout);
   
    always@(*) begin

        {cout,sum}=a+b+cin;

    end

endmodule