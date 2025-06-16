`timescale 1ns / 1ps
`include "q1.v"

module tb_FloatingPointAddition;
    reg [31:0] a_operand; // Input in IEEE-754 format
    reg [31:0] b_operand; // Input in IEEE-754 format
    wire Exception;       // Exception output flag
    wire [31:0] result;  // Result output in IEEE-754 format

    // Instantiate the FloatingPointAddition module
    FloatingPointAddition uut (
        .a_operand(a_operand),
        .b_operand(b_operand),
        .Exception(Exception),
        .result(result)
    );

    // Array to hold expected results
    reg [31:0] expected_results [0:7] ;
    reg exception[0:7];
    integer i;

    initial begin
        // Initialize expected results
        expected_results[0] = 32'h40E00000; // Expected Result: 7.0 (5.0 + 2.0)
        exception[0]=1'b0;
        expected_results[1] = 32'h40A00000; // Expected Result: 5.0 (5.0 + 0.0)
        exception[1]=1'b0;
        expected_results[2] = 32'h7f800000; // Expected Result: Infinity (Infinity + -2.0)
        exception[2]=1'b1;
        expected_results[3] = 32'h7f800000; // Expected Result: 0 (NaN + 5.0)
        exception[3]=1'b1;
        expected_results[4] = 32'h41000000; // Expected Result: 8.0 (8.0 + small number)
        exception[4]=1'b0;
        expected_results[5] = 32'hC0900000; // Expected Result: -4.5 (-2.0 + -2.5)
        exception[5]=1'b0;
        expected_results[6] = 32'h4B703ACD; // Expected Result: 15743693 (15742268+ 1425)
        exception[6]=1'b0;
        expected_results[7] = 32'h3B289763; // Expected Result: 0.002572 (0.00256+ 0.0000125)
        exception[7]=1'b0;
        a_operand = 32'h40A00000; // 5.0
        b_operand = 32'h40000000; // 2.0
        #10; // Wait for a short period
        check_result(0);

        a_operand = 32'h40A00000; // 5.0
        b_operand = 32'h00000000; // 0.0
        #10;
        check_result(1);

        a_operand = 32'h7F800000; // +Infinity
        b_operand = 32'hC0000000; // -2.0
        #10;
        check_result(2);

        a_operand = 32'h7FC00000; // NaN
        b_operand = 32'h40A00000; // 5.0
        #10;
        check_result(3);

        a_operand = 32'h41000000; // 8.0
        b_operand = 32'h00000001; // Very small number
        #10;
        check_result(4);

        a_operand = 32'hC0000000; // -2.0
        b_operand = 32'hC0200000; // -2.5
        #10;
        check_result(5);

        a_operand = 32'h4B70353C; // 15742268
        b_operand = 32'h44B22000; // 1425
        #10;
        check_result(6);
        a_operand = 32'h3B27C5AC; // 0.00256
        b_operand = 32'h3751B717; // 0.0000125
        #10;
        check_result(7);
        // End of test
        $finish;
    end

    // Task to check result against expected value
    task check_result(input integer test_case);
    begin
        // Check if the obtained result and Exception match expected values
        if (result === expected_results[test_case] && Exception === exception[test_case]) begin
            $display("Test Case %0d PASSED: Expected = %h, Obtained = %h, Exception = %b", 
                    test_case, expected_results[test_case], result, Exception);
        end else begin
            $display("Test Case %0d FAILED: Expected = %h, Obtained = %h, Exception = %b", 
                    test_case, expected_results[test_case], result, Exception);
        end
    end
    endtask

endmodule
