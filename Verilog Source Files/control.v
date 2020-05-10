module Control(OpCode, func, RegDest, Branch, BranchNot, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, JumpR, Jal, clk);
	input clk;
	input [5:0] OpCode, func;
	output reg RegDest, Branch, BranchNot, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, Jump, JumpR, Jal;
	output reg [3:0]ALUOp;
	
	initial begin
		{RegDest, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, Jump} <= 00000000;
		ALUOp = 0;
		BranchNot = 0;
		JumpR = 0;
	end
	
	always @(OpCode or func)
	begin
		if(OpCode == 0)       // OpCode of R type
		begin
			{Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump}
			<= 000010;
			MemToReg = 0;
			RegDest = 1;
			ALUOp = 4'b0000;
			BranchNot = 0;
			JumpR = (func == 8);
			Jal = 0;
		end
		else if(OpCode == 35) // OpCode of the LW
		begin
			{ Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump}
			<= 010110;
			MemToReg = 1;
			RegDest = 0;
			ALUOp = 4'b0010;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if(OpCode == 43) // OpCode of the SW
		begin
			{Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump}
			<= 001100; // RegDest and MemToReg are dont cares
			RegDest = 1'bx;
			MemToReg = 1'bx;
			ALUOp = 4'b0010;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if(OpCode == 4) // OpCode of the beq
		begin
			{Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump}
			<= 100000; // RegDest and MemToReg are dont cares
			RegDest = 1'bx;
			MemToReg = 1'bx;
			ALUOp = 4'b0110;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 2) // opcode of the jump 
		begin
			{MemRead, MemWrite, RegWrite, Jump}
			<= 0001;
			ALUSrc =1'bx;
			Branch = 1'bx;
			RegDest = 1'bx;	
			MemToReg = 1'bx;
			ALUOp = 4'bxxxx;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 3) // opcode of the jal
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0011;
			Branch = 1'b0;
			ALUSrc = 1'bx;
			RegDest = 1'b1;	
			MemToReg = 0;
			ALUOp = 4'bxxxx;
			BranchNot = 0;
			JumpR = 0;
			Jal = 1;
		end
		else if (OpCode == 8) // addi
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 4'b0010;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		
		else if (OpCode == 12) // andi
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 4'b0000;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 13) // ori
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 4'b0001;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 14) // xori
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 13;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 10) // slti
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 7;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 32) // lb
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 1010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 4'b0110;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 15) // lui
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0010;
			Branch = 0;
			ALUSrc = 1;
			RegDest = 0;
			MemToReg = 0;
			ALUOp = 14;
			BranchNot = 0;
			JumpR = 0;
			Jal = 0;
		end
		else if (OpCode == 5) // bne
		begin
			{ MemRead, MemWrite, RegWrite, Jump} <= 0000;
			Branch = 0;
			ALUSrc = 1'b0;
			RegDest = 1'bx;
			MemToReg = 1'bx;
			ALUOp = 6;
			BranchNot = 1;
			JumpR = 0;
			Jal = 0;
		end
	end
endmodule

