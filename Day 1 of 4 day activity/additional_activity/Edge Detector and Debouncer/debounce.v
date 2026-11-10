module debounce (
    input clk, rst, noisy_in,
    output reg clean_out
);
    reg [1:0] sync;
    reg [3:0] counter; // Adjust depth for real hardware clock speed
    
    // Two-flop synchronizer
    always @(posedge clk) begin
        if (rst) sync <= 2'b0;
        else sync <= {sync[0], noisy_in};
    end
    
    wire sync_in = sync[1];
    
    always @(posedge clk) begin
        if (rst) begin
            counter <= 4'b0;
            clean_out <= 1'b0;
        end else begin
            if (clean_out !== sync_in) begin
                if (counter == 4'hF) begin
                    clean_out <= sync_in;
                    counter <= 4'b0;
                end else counter <= counter + 1;
            end else counter <= 4'b0;
        end
    end
endmodule