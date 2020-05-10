module ALUControl(ALUOp, Func, Sel);
	input [5:0] Func;
	input [2:0] ALUOp;
	output reg [3:0]  Sel;
	always@(ALUOp or Func)
        begin
		if( ALUOp == 0)
		begin
			if(Func == 32) 		// add
				Sel = 2;
			else if (Func == 34) 	// sub
				Sel = 6;
			else if (Func == 36) 	// and
				Sel = 0;
			else if (Func == 37) 	// 0r
				Sel = 1;
			else if (Func == 42) 	// slt
				Sel = 7;
			else if (Func == 39) 	// nor
				Sel = 12;
			else if (Func == 38) 	// xor
				Sel = 13;
			else if (Func == 0) 	// sll
				Sel = 14;
			else if (Func == 2) 	// srl
				Sel = 15;
			else if (Func == 3) 	// sra
				Sel = 11;
		end

		else // lw sw lui
			Sel = ALUOp;
	end
endmodule
