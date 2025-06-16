`timescale 1ns / 1ps
`include "q2.v"

module tb_floating_point_mult();

    reg [31:0] a, b;         // Inputs to the multiplier (floating-point numbers)
    wire [31:0] product;      // Output product
    wire exception;           // Exception flag (overflow/underflow/NaN)
    wire overflow;
    wire underflow;

    // Instantiate the multiplier module
    floating_point_mult uut (
        .a(a),
        .b(b),
        .product(product),
        .exception(exception),
        .overflow(overflow),
        .underflow(underflow)
    );

    initial begin
        // Test cases with expected results
        // Test case 1: 2.5 * 4.0 = 10.0
        a = 32'h40200000; // 2.5
        b = 32'h40800000; // 4.0
        #10; 
        check_case(32'h41200000, 1'b0, 1'b0, 1'b0); // Expected: 10.0, No exception

        // Test case 2: Max positive float * 1.0 = Infinity
        a = 32'h7F7FFFFF; // Max float
        b = 32'h44440000; // 748
        #10;
        check_case(32'h7F800000, 1'b1, 1'b1, 1'b0); // Expected: Infinity, Exception, Overflow

        // Test case 3: Small * Small = 0 (underflow)
        a = 32'h00800000; // Small positive float
        b = 32'h00800000; // Another small positive float
        #10;
        check_case(32'h00000000, 1'b1, 1'b0, 1'b1); // Expected: 0, Exception, Underflow

        // Test case 4: NaN * 1.0 = NaN
        a = 32'h7FC00000; // NaN
        b = 32'h3F800000; // 1.0
        #10;
        check_case(32'h7FC00000, 1'b1, 1'b0, 1'b0); // Expected: NaN, Exception

        // Test case 5: Positive infinity * Positive number = Infinity
        a = 32'h7F800000; // Positive infinity
        b = 32'h40000000; // 2.0
        #10;
        check_case(32'h7F800000, 1'b1, 1'b0, 1'b0); // Expected: Infinity, No exception

        // Test case 6: Negative infinity * Negative number = Infinity
        a = 32'hFF800000; // Negative infinity
        b = 32'hC0000000; // -2.0
        #10;
        check_case(32'h7F800000, 1'b1, 1'b0, 1'b0); // Expected: Infinity, No exception

        // Test case 7: 0 * any number = 0
        a = 32'h00000000; // Zero
        b = 32'h40400000; // 3.0
        #10;
        check_case(32'h00000000, 1'b1, 1'b0, 1'b0); // Expected: 0, No exception

        // Test case 8: Negative Zero * Positive number = Negative Zero
        a = 32'h80000000; // Negative Zero
        b = 32'h40400000; // 3.0
        #10;
        check_case(32'h80000000, 1'b1, 1'b0, 1'b0); // Expected: Negative Zero, No exception

        $finish; // End the simulation
    end

    // Task to check result against expected value
    task check_case(input [31:0] expected_product, input expected_exception, 
                    input expected_overflow, input expected_underflow);
    begin
        if (product === expected_product && exception === expected_exception &&
            overflow === expected_overflow && underflow === expected_underflow) 
        begin
            $display("Test PASSED: Expected = %h, Obtained = %h, Exception = %b, Overflow = %b, Underflow = %b", 
                     expected_product, product, exception, overflow, underflow);
        end else begin
            $display("Test FAILED: Expected = %h, Obtained = %h, Exception = %b, Overflow = %b, Underflow = %b", 
                     expected_product, product, exception, overflow, underflow);
        end
    end
    endtask

endmodule
