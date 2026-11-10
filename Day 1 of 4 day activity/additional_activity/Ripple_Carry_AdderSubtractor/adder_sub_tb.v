`timescale 1ns/1ps
module adder_sub_tb;
    reg [7:0] a, b;
    reg mode;
    wire [7:0] result;
    wire cout, overflow;
    
    integer i, j, errors = 0;
    reg [8:0] expected_full;
    reg expected_ovf;

    adder_sub uut (.a(a), .b(b), .mode(mode), .result(result), .cout(cout), .overflow(overflow));

    initial begin
        // Exhaustive test for Add and Subtract
        for (mode = 0; mode <= 1; mode = mode + 1) begin
            for (i = 0; i < 256; i = i + 1) begin
                for (j = 0; j < 256; j = j + 1) begin
                    a = i; b = j; #1;
                    
                    if (mode == 0) expected_full = a + b;
                    else expected_full = a - b;
                    
                    expected_ovf = (mode == 0) ? 
                        (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]) :
                        (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
                        
                    if (result !== expected_full[7:0] || overflow !== expected_ovf) begin
                        $display("FAIL: a=%h b=%h mode=%b | Res=%h Ovf=%b | ExpRes=%h ExpOvf=%b", 
                                 a, b, mode, result, overflow, expected_full[7:0], expected_ovf);
                        errors = errors + 1;
                    end
                end
            end
        end
        if (errors == 0) $display("PASS: All Adder/Subtractor tests passed."); //[cite: 2]
        else $display("Finished with %0d errors.", errors);
        $finish;
    end
endmodule