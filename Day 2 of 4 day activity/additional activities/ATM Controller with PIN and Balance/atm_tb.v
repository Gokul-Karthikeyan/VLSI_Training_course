`timescale 1ns/1ps
module atm_tb;
    reg clk, rst, card_insert, card_remove, pin_enter, withdraw_req;
    reg [15:0] pin_in, amount_req;
    wire locked, dispense, reject_funds, reject_pin;
    wire [15:0] balance_out;
    
    integer errors = 0;

    atm dut (
        .clk(clk), .rst(rst), .card_insert(card_insert), .card_remove(card_remove),
        .pin_enter(pin_enter), .pin_in(pin_in), .withdraw_req(withdraw_req), .amount_req(amount_req),
        .locked(locked), .balance_out(balance_out), .dispense(dispense), 
        .reject_funds(reject_funds), .reject_pin(reject_pin)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; card_insert = 0; card_remove = 0; 
        pin_enter = 0; pin_in = 0; withdraw_req = 0; amount_req = 0;
        #15 rst = 0;

        // Scenario 1: Correct PIN and Successful Withdrawal
        card_insert = 1; #10; card_insert = 0; #10;
        pin_in = 16'd1234; pin_enter = 1; #10; pin_enter = 0; #10;
        amount_req = 16'd2000; withdraw_req = 1; #10; withdraw_req = 0; #10;
        if (dispense !== 1 || balance_out !== 16'd3000) errors = errors + 1;
        card_remove = 1; #10; card_remove = 0; #10;

        // Scenario 2: Insufficient Balance
        card_insert = 1; #10; card_insert = 0; #10;
        pin_in = 16'd1234; pin_enter = 1; #10; pin_enter = 0; #10;
        amount_req = 16'd4000; withdraw_req = 1; #10; withdraw_req = 0; #10;
        if (reject_funds !== 1 || balance_out !== 16'd3000) errors = errors + 1;
        card_remove = 1; #10; card_remove = 0; #10;

        // Scenario 3: Wrong PIN three times resulting in lock
        card_insert = 1; #10; card_insert = 0; #10;
        pin_in = 16'd0000; pin_enter = 1; #10; pin_enter = 0; #10; // Attempt 1
        pin_in = 16'd1111; pin_enter = 1; #10; pin_enter = 0; #10; // Attempt 2
        pin_in = 16'd2222; pin_enter = 1; #10; pin_enter = 0; #10; // Attempt 3
        if (locked !== 1) errors = errors + 1;

        if (errors == 0) $display("PASS: All ATM Controller tests passed.");
        else $display("FAIL: ATM Controller had %0d errors.", errors);
        $finish;
    end
endmodule