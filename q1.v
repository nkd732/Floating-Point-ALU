module full_subtractor (input A, B, Bin, output D, Bout);
   assign D = A ^ B ^ Bin;
   assign Bout = (A & B) | (Bin & ((A ^ B)));
endmodule

module sub (input [7:0] A, B, input borrow_in, output borrow_out, output [7:0] difference);
    wire B1, B2, B3, B4, B5, B6, B7;

    full_subtractor FS0 (A[0], B[0], borrow_in, difference[0], B1);
    full_subtractor FS1 (A[1], B[1], B1, difference[1], B2);
    full_subtractor FS2 (A[2], B[2], B2, difference[2], B3);
    full_subtractor FS3 (A[3], B[3], B3, difference[3], B4);
    full_subtractor FS4 (A[4], B[4], B4, difference[4], B5);
    full_subtractor FS5 (A[5], B[5], B5, difference[5], B6);
    full_subtractor FS6 (A[6], B[6], B6, difference[6], B7);
    full_subtractor FS7 (A[7], B[7], B7, difference[7], borrow_out);

endmodule
module CLA4 (input [3:0] A, input [3:0] B, input carry_in, output carry_out, output [3:0] sum);

    wire [3:0] p, g;  
    wire c1, c2, c3;  

    xor (p[0], A[0], B[0]);
    xor (p[1], A[1], B[1]);
    xor (p[2], A[2], B[2]);
    xor (p[3], A[3], B[3]);

    and (g[0], A[0], B[0]);
    and (g[1], A[1], B[1]);
    and (g[2], A[2], B[2]);
    and (g[3], A[3], B[3]);
    
    wire n1,n2,n3,n4;

    and (n1,p[0],carry_in);
    or (c1,g[0],n1);
    and (n2,p[1],c1);
    or (c2,g[1],n2);
    and (n3,p[2],c2);
    or (c3,g[2],n3);
    and (n4,p[3],c3);
    or (carry_out,g[3],n4);

    xor (sum[0], p[0], carry_in);
    xor (sum[1], p[1], c1);
    xor (sum[2], p[2], c2);
    xor (sum[3], p[3], c3);

endmodule

module CLA8 (input [7:0] A,input [7:0] B,input carry_in,output carry_out,output [7:0] sum);

    wire carry_out1, carry_out2;

    CLA4 cla_lower (.A(A[3:0]),.B(B[3:0]),.carry_in(carry_in),.carry_out(carry_out1),.sum(sum[3:0]));
    CLA4 cla_upper (.A(A[7:4]),.B(B[7:4]),.carry_in(carry_out1),.carry_out(carry_out2),.sum(sum[7:4]));

    assign carry_out = carry_out2;

endmodule

module CLA24 (input [23:0] A, input [23:0] B, input carry_in, output carry_out, output [23:0] sum);

    wire c1, c2, c3, c4, c5; 

    CLA4 cla0 (.A(A[3:0]),   .B(B[3:0]),   .carry_in(carry_in), .carry_out(c1), .sum(sum[3:0]));
    CLA4 cla1 (.A(A[7:4]),   .B(B[7:4]),   .carry_in(c1),       .carry_out(c2), .sum(sum[7:4]));
    CLA4 cla2 (.A(A[11:8]),  .B(B[11:8]),  .carry_in(c2),       .carry_out(c3), .sum(sum[11:8]));
    CLA4 cla3 (.A(A[15:12]), .B(B[15:12]), .carry_in(c3),       .carry_out(c4), .sum(sum[15:12]));
    CLA4 cla4 (.A(A[19:16]), .B(B[19:16]), .carry_in(c4),       .carry_out(c5), .sum(sum[19:16]));
    CLA4 cla5 (.A(A[23:20]), .B(B[23:20]), .carry_in(c5),       .carry_out(carry_out), .sum(sum[23:20]));

endmodule

module bit8_2to1_mux (input [7:0] A, input [7:0] B, input sel, output [7:0] Y);

    wire [7:0] diff;
    wire s,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15;
    not(s,sel);
    and(t0,s,A);
    and(t1,sel,B);
    or(Y[0],t0,t1);
    and(t2,s,A);
    and(t3,sel,B);
    or(Y[1],t2,t3);
    and(t4,s,A);
    and(t5,sel,B);
    or(Y[2],t4,t5);
    and(t6,s,A);
    and(t7,sel,B);
    or(Y[3],t6,t7);
    and(t8,s,A);
    and(t9,sel,B);
    or(Y[4],t8,t9);
    and(t10,s,A);
    and(t11,sel,B);
    or(Y[5],t10,t11);
    and(t12,s,A);
    and(t13,sel,B);
    or(Y[6],t12,t13);
    and(t14,s,A);
    and(t15,sel,B);
    or(Y[7],t14,t15);

endmodule

module bit24_2to1_mux (input [23:0] A, input [23:0] B, input sel, output [23:0] Y);

    wire s;
    wire [47:0] t; 

    not(s, sel);

    and(t[0], s, A[0]);
    and(t[1], sel, B[0]);
    or(Y[0], t[0], t[1]);

    and(t[2], s, A[1]);
    and(t[3], sel, B[1]);
    or(Y[1], t[2], t[3]);

    and(t[4], s, A[2]);
    and(t[5], sel, B[2]);
    or(Y[2], t[4], t[5]);

    and(t[6], s, A[3]);
    and(t[7], sel, B[3]);
    or(Y[3], t[6], t[7]);

    and(t[8], s, A[4]);
    and(t[9], sel, B[4]);
    or(Y[4], t[8], t[9]);

    and(t[10], s, A[5]);
    and(t[11], sel, B[5]);
    or(Y[5], t[10], t[11]);

    and(t[12], s, A[6]);
    and(t[13], sel, B[6]);
    or(Y[6], t[12], t[13]);

    and(t[14], s, A[7]);
    and(t[15], sel, B[7]);
    or(Y[7], t[14], t[15]);

    and(t[16], s, A[8]);
    and(t[17], sel, B[8]);
    or(Y[8], t[16], t[17]);

    and(t[18], s, A[9]);
    and(t[19], sel, B[9]);
    or(Y[9], t[18], t[19]);

    and(t[20], s, A[10]);
    and(t[21], sel, B[10]);
    or(Y[10], t[20], t[21]);

    and(t[22], s, A[11]);
    and(t[23], sel, B[11]);
    or(Y[11], t[22], t[23]);

    and(t[24], s, A[12]);
    and(t[25], sel, B[12]);
    or(Y[12], t[24], t[25]);

    and(t[26], s, A[13]);
    and(t[27], sel, B[13]);
    or(Y[13], t[26], t[27]);

    and(t[28], s, A[14]);
    and(t[29], sel, B[14]);
    or(Y[14], t[28], t[29]);

    and(t[30], s, A[15]);
    and(t[31], sel, B[15]);
    or(Y[15], t[30], t[31]);

    and(t[32], s, A[16]);
    and(t[33], sel, B[16]);
    or(Y[16], t[32], t[33]);

    and(t[34], s, A[17]);
    and(t[35], sel, B[17]);
    or(Y[17], t[34], t[35]);

    and(t[36], s, A[18]);
    and(t[37], sel, B[18]);
    or(Y[18], t[36], t[37]);

    and(t[38], s, A[19]);
    and(t[39], sel, B[19]);
    or(Y[19], t[38], t[39]);

    and(t[40], s, A[20]);
    and(t[41], sel, B[20]);
    or(Y[20], t[40], t[41]);

    and(t[42], s, A[21]);
    and(t[43], sel, B[21]);
    or(Y[21], t[42], t[43]);

    and(t[44], s, A[22]);
    and(t[45], sel, B[22]);
    or(Y[22], t[44], t[45]);

    and(t[46], s, A[23]);
    and(t[47], sel, B[23]);
    or(Y[23], t[46], t[47]);

endmodule

module mux32to1 (input [23:0] A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15,A16, A17, A18, A19, A20, A21, A22, A23,A24, A25, A26, A27, A28, A29, A30, A31,  input [4:0] sel, output reg [23:0] Y);                           

    always @(*) begin
        case (sel)
            5'd0: Y = A0;
            5'd1: Y = A1;
            5'd2: Y = A2;
            5'd3: Y = A3;
            5'd4: Y = A4;
            5'd5: Y = A5;
            5'd6: Y = A6;
            5'd7: Y = A7;
            5'd8: Y = A8;
            5'd9: Y = A9;
            5'd10: Y = A10;
            5'd11: Y = A11;
            5'd12: Y = A12;
            5'd13: Y = A13;
            5'd14: Y = A14;
            5'd15: Y = A15;
            5'd16: Y = A16;
            5'd17: Y = A17;
            5'd18: Y = A18;
            5'd19: Y = A19;
            5'd20: Y = A20;
            5'd21: Y = A21;
            5'd22: Y = A22;
            5'd23: Y = A23;
            5'd24: Y = A24;
            5'd25: Y = A25;
            5'd26: Y = A26;
            5'd27: Y = A27;
            5'd28: Y = A28;
            5'd29: Y = A29;
            5'd30: Y = A30;
            5'd31: Y = A31;
            default: Y = 24'd0; 
        endcase
    end

endmodule

module priority_encoder(input [24:0] A, output reg [4:0] d);
    always @* begin
        if (sum[24])
            leading_zeroes = 5'b00000;
        else if (sum[23])
            leading_zeroes = 5'b00001;
        else if (sum[22])
            leading_zeroes = 5'b00010;
        else if (sum[21])
            leading_zeroes = 5'b00011;
        else if (sum[20])
            leading_zeroes = 5'b00100;
        else if (sum[19])
            leading_zeroes = 5'b00101;
        else if (sum[18])
            leading_zeroes = 5'b00110;
        else if (sum[17])
            leading_zeroes = 5'b00111;
        else if (sum[16])
            leading_zeroes = 5'b01000;
        else if (sum[15])
            leading_zeroes = 5'b01001;
        else if (sum[14])
            leading_zeroes = 5'b01010;
        else if (sum[13])
            leading_zeroes = 5'b01011;
        else if (sum[12])
            leading_zeroes = 5'b01100;
        else if (sum[11])
            leading_zeroes = 5'b01101;
        else if (sum[10])
            leading_zeroes = 5'b01110;
        else if (sum[9])
            leading_zeroes = 5'b01111;
        else if (sum[8])
            leading_zeroes = 5'b10000;
        else if (sum[7])
            leading_zeroes = 5'b10001;
        else if (sum[6])
            leading_zeroes = 5'b10010;
        else if (sum[5])
            leading_zeroes = 5'b10011;
        else if (sum[4])
            leading_zeroes = 5'b10100;
        else if (sum[3])
            leading_zeroes = 5'b10101;
        else if (sum[2])
            leading_zeroes = 5'b10110;
        else if (sum[1])
            leading_zeroes = 5'b10111;
        else if (sum[0])
            leading_zeroes = 5'b11000;  
        else
            leading_zeroes = 5'b11000;  
    end
endmodule

module FloatingPointAddition (
    input [31:0] a_operand, 
    input [31:0] b_operand, 
    output Exception,  
    output [31:0] result
);

    wire borrow, borrow1, borrow2, carry, carry0;
    wire [7:0] exp_diff, exp_diff1, exp_diff2, exp, D, G, R;       
    wire [23:0] mantissa, mantissa1, mantissa2, mantissa3, P, S, T;
    wire [24:0] Q;
    wire [4:0] d;        

    // Extracting exponent and mantissa from operands
    wire [7:0] exponent_A = a_operand[30:23];  
    wire [7:0] exponent_B = b_operand[30:23];  
    wire [22:0] mantissa_A = a_operand[22:0];    
    wire [22:0] mantissa_B = b_operand[22:0];  

    assign mantissa1 = {1'b1, mantissa_A};  // Adding implicit leading 1
    assign mantissa2 = {1'b1, mantissa_B};

    // Subtract exponents
    sub cla1(.A(exponent_A), .B(exponent_B), .borrow_in(1'b0), .borrow_out(borrow1), .difference(exp_diff1));
    sub cla2(.A(exponent_B), .B(exponent_A), .borrow_in(1'b0), .borrow_out(borrow2), .difference(exp_diff2));

    // Mux to determine which mantissa and exponent to align
    bit8_2to1_mux mux1(.A(exp_diff1), .B(exp_diff2), .sel(borrow1), .Y(exp_diff));
    bit24_2to1_mux mux2(.A(mantissa1), .B(mantissa2), .sel(borrow1), .Y(P));
    bit24_2to1_mux mux3(.A(mantissa2), .B(mantissa1), .sel(borrow1), .Y(S));

    // Shift mantissa S based on exponent difference using multiple shift options
    wire [23:0] s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24;
    assign s0=S[23:0];
    assign s1={1'b0,S[23:1]};
    assign s2={2'b00,S[23:2]};
    assign s3={3'b000,S[23:3]};
    assign s4={4'b0000,S[23:4]};
    assign s5={5'b00000,S[23:5]};
    assign s6={6'b000000,S[23:6]};
    assign s7={7'b0000000,S[23:7]};
    assign s8={8'b00000000,S[23:8]};
    assign s9={9'b000000000,S[23:9]};
    assign s10={10'b0000000000,S[23:10]};
    assign s11={11'b00000000000,S[23:11]};
    assign s12={12'b000000000000,S[23:12]};
    assign s13={13'b0000000000000,S[23:13]};
    assign s14={14'b00000000000000,S[23:14]};
    assign s15={15'b000000000000000,S[23:15]};
    assign s16={16'b0000000000000000,S[23:16]};
    assign s17={17'b00000000000000000,S[23:17]};
    assign s18={18'b000000000000000000,S[23:18]};
    assign s19={19'b0000000000000000000,S[23:19]};
    assign s20={20'b00000000000000000000,S[23:20]};
    assign s21={21'b000000000000000000000,S[23:21]};
    assign s22={22'b0000000000000000000000,S[23:22]};
    assign s23={23'b00000000000000000000000,S[23]};
    assign s24=24'b000000000000000000000000;

    mux32to1 mux4(.A0(s0), .A1(s1), .A2(s2), .A3(s3), .A4(s4), .A5(s5), .A6(s6), .A7(s7), .A8(s8), .A9(s9), .A10(s10), .A11(s11), .A12(s12), .A13(s13), .A14(s14), .A15(s15), .A16(s16), .A17(s17), .A18(s18), .A19(s19), .A20(s20), .A21(s21), .A22(s22), .A23(s23), .A24(s24), .A25(s24), .A26(s24), .A27(s24), .A28(s24), .A29(s24), .A30(s24), .A31(s24), .sel(d[4:0]), .Y(T));
        
    // Handle overflow from addition
    bit24_2to1_mux mux5(.A(s24), .B(mantissa3), .sel(exp_diff[7]|exp_diff[6]|exp_diff[5]), .Y(mantissa));

    // Add aligned mantissas
    CLA24 adder(.A(P), .B(mantissa), .carry_in(1'b0), .carry_out(carry), .sum(Q[23:0]));
    assign Q[24] = carry;

    // Priority encoder to normalize result
    priority_encoder pe(.A(Q), .d(d));

    // Adjust the exponent after addition
    assign D = {3'b000, d};
    bit8_2to1_mux mux6(.A(exponent_A), .B(exponent_B), .sel(borrow1), .Y(G));
    CLA8 cla10(.A(G), .B(8'b00000001), .carry_in(1'b0), .carry_out(carry0), .sum(R));
    sub cla11(.A(R), .B(D), .borrow_in(1'b0), .borrow_out(borrow), .difference(exp));

    // Normalize Q result
    wire [23:0] q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24;
    assign q0 = Q[23:0];
    assign q1 = {1'b0, Q[23:1]};
    assign q2 = {2'b00, Q[23:2]};
    assign q3 = {3'b000, Q[23:3]};
    assign q4 = {4'b0000, Q[23:4]};
    assign q5 = {5'b00000, Q[23:5]};
    assign q6 = {6'b000000, Q[23:6]};
    assign q7 = {7'b0000000, Q[23:7]};
    assign q8 = {8'b00000000, Q[23:8]};
    assign q9 = {9'b000000000, Q[23:9]};
    assign q10 = {10'b0000000000, Q[23:10]};
    assign q11 = {11'b00000000000, Q[23:11]};
    assign q12 = {12'b000000000000, Q[23:12]};
    assign q13 = {13'b0000000000000, Q[23:13]};
    assign q14 = {14'b00000000000000, Q[23:14]};
    assign q15 = {15'b000000000000000, Q[23:15]};
    assign q16 = {16'b0000000000000000, Q[23:16]};
    assign q17 = {17'b00000000000000000, Q[23:17]};
    assign q18 = {18'b000000000000000000, Q[23:18]};
    assign q19 = {19'b0000000000000000000, Q[23:19]};
    assign q20 = {20'b00000000000000000000, Q[23:20]};
    assign q21 = {21'b000000000000000000000, Q[23:21]};
    assign q22 = {22'b0000000000000000000000, Q[23:22]};
    assign q23 = {23'b00000000000000000000000, Q[23]};
    assign q24 = 24'b000000000000000000000000;

    mux32to1 mux7(.A0(q0),.A1(q1),.A2(q2),.A3(q3),.A4(q4),.A5(q5),.A6(q6),.A7(q7),.A8(q8),.A9(q9),.A10(q10),.A11(q11),.A12(q12),.A13(q13),.A14(q14),.A15(q15),.A16(q16),.A17(q17),.A18(q18),.A19(q19),.A20(q20),.A21(q21),.A22(q22),.A23(q23),.A24(q24),.A25(q24),  .A26(q24),.A27(q24),.A28(q24),.A29(q24),.A30(q24),.A31(q24),.sel(d[4:0]),.Y(T));


    // Handle sign, exponent, and mantissa for the result
    assign result[31] = a_operand[31] ^ b_operand[31];  // XOR sign bits for result
    assign result[30:23] = exp;                          // Assign exponent
    assign result[22:0] = T[22:0];                       // Assign mantissa

    // Exception: if either operand is NaN or infinity
    assign Exception = (&a_operand[30:23]) | (&b_operand[30:23]);

endmodule