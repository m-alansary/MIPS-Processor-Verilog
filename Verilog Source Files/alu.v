module ALU(A, B, ALUCtrl, ALUOut, shamt, Zero);
	input wire [3:0] ALUCtrl;
	input wire [4:0] shamt;
	input wire [31:0] A;
	input wire [31:0] B;
	output reg [31:0] ALUOut;
	output Zero;
	
	initial begin
		ALUOut = 0;
	end
	
	assign Zero = (ALUOut == 0) ? 1 : 0;
	always @(ALUCtrl, A, B)
	begin
		case(ALUCtrl)
			0: 	ALUOut <= A & B;
			1: 	ALUOut <= A | B;
			2: 	ALUOut <= A + B;
			6: 	ALUOut <= A - B;
			7: 	ALUOut <= A < B ? 1 : 0;
			12: 	ALUOut <= ~(A | B);
			13: 	ALUOut <= ~(A ^ B);
			14: 	ALUOut <= (B << shamt);
			15: 	ALUOut <= (B >> shamt);
			11: 	ALUOut <= (B >>> shamt);  // sra
			17:	ALUOut <= (B << 16); 	 // lui
			default: ALUOut <= 0; 
		endcase
	end
endmodule



