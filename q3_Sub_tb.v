

`include "q3.v"
`define N_TESTS 1000

module Addition_tb;

	reg clk = 0;
	reg [31:0] a_operand;
	reg [31:0] b_operand;
	reg AddBar_Sub = 1'b1;
	
	wire [31:0] result;

	reg [31:0] Expected_result;

	reg [95:0] testVector [0:`N_TESTS-1];

	reg test_stop_enable;

	integer test_n = 0;
	integer pass   = 0;
	integer error  = 0;

	Addition_Subtraction DUT(a_operand,b_operand,AddBar_Sub,,result);

	always #5 clk = ~clk;

	initial  
	begin 
		$readmemh("TestVectorSubtraction", testVector);
	end 

	always @(posedge clk) 
	begin
			{a_operand,b_operand,Expected_result} = testVector[test_n];
			test_n = test_n + 1'b1;

			#2;
			if (result[31:11] == Expected_result[31:11])
				begin
					//$display ("TestPassed Test Number -> %d",test_n);
					pass = pass + 1'b1;
				end

			if (result[31:11] != Expected_result[31:11])
				begin
					$display ("Test Failed Expected Result = %h, Obtained result = %h, Test Number -> %d",Expected_result,result,test_n);
					error = error + 1'b1;
				end
			
			if (test_n >= `N_TESTS) 
			begin
				$display("Completed %d tests, %d passes and %d fails.", test_n, pass, error);
				test_stop_enable = 1'b1;
			end
	end

always @(posedge test_stop_enable)
begin
$finish;
end

endmodule
