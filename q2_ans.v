module floating_point_mult (
    input [31:0] a, // First IEEE-754 floating point number
    input [31:0] b, // Second IEEE-754 floating point number
    output reg [31:0] product, // Product of a and b in IEEE-754 format
    output reg exception, // Flag for exception (overflow/underflow/Special case)
    output reg overflow, // Flag for overflow
    output reg underflow // Flag for underflow
);

    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exponent_a = a[30:23];
    wire [7:0] exponent_b = b[30:23];
    wire [23:0] mantissa_a = {1'b1, a[22:0]};
    wire [23:0] mantissa_b = {1'b1, b[22:0]};

    wire sign_product = sign_a ^ sign_b;
    wire [47:0] mantissa_product = mantissa_a * mantissa_b;
    wire [7:0] exponent_product = exponent_a + exponent_b - 8'd127;

    always @(*) begin
        exception = 1'b0;
        overflow = 1'b0;
        underflow = 1'b0;

        if (exponent_a == 8'd255 || exponent_b == 8'd255) begin
            // Special case: NaN or infinity
            product = {sign_product, 8'd255, 23'b0};
            exception = 1'b1;
        end else if (exponent_a == 8'd0 || exponent_b == 8'd0) begin
            // Special case: zero or subnormal number
            product = {sign_product, 8'd0, 23'b0};
            exception = 1'b1;
        end else begin
            // Normalize the result
            if (mantissa_product[47]) begin
                product = {sign_product, exponent_product + 8'd1, mantissa_product[46:24]};
            end else begin
                product = {sign_product, exponent_product, mantissa_product[45:23]};
            end

            // Check for overflow and underflow
            if (exponent_product >= 8'd255) begin
                product = {sign_product, 8'd255, 23'b0}; // Set to infinity
                overflow = 1'b1;
            end else if (exponent_product <= 8'd0) begin
                product = {sign_product, 8'd0, 23'b0}; // Set to zero
                underflow = 1'b1;
            end
        end
    end
endmodule
