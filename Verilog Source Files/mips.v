module mipsTB();
    reg clk = 1;
    reg [31:0] PC = -4;    
    wire [31:0] PCwire = 0;
    wire [31:0] ins;
    wire [5:0] OpCode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [5:0] func;
    wire [15:0] imValue;
    wire [31:0] jump_label;
    wire MemToRegControl;
    wire [4:0] writeRegAdress;
    wire [4:0] mux1Out;
    wire [31:0] reg1Data;
    wire [31:0] mux2Out;
    wire [31:0] reg2Data;
    wire [31:0] immediateValue32;
    wire [31:0] in_alu2;
    wire zero;
    wire [31:0] alu_output;
    wire [31:0] data_memory_data;
    wire [31:0] regFile_writeData;
    wire regDstC;
    wire Jump;
    wire JumpR;
    wire Jal;
    wire Branch;
    wire BranchNot;
    wire memReadC;
    wire memToRegC;
    wire [3:0] aluOpC;
    wire memWriteC;
    wire aluSrcC;
    wire regWriteC;
    wire [3:0] aluControlOutput;
    wire pcBranchSel;
    wire [31:0]branchRelativeValue;
    wire [31:0]pcNewValue;
    wire [31:0]pcBranchOut;

    ALU alu(reg1Data, in_alu2, aluControlOutput, alu_output, shamt, zero);
    ALUControl alu_control(aluOpC, func, aluControlOutput);
    Control controlUnit(OpCode, func, regDstC, Branch, BranchNot, memReadC, memToRegC, aluOpC, memWriteC, aluSrcC, regWriteC, Jump, JumpR, Jal, clk);
    RegFile regFile(reg1Data,reg2Data,regWriteC,rs,rt,writeRegAdress,regFile_writeData,clk);
    DataMem data_memory(data_memory_data,alu_output,reg2Data,memReadC,memWriteC);
    InstMem insMemory(ins,PC);
    Mux_5 regDist(mux1Out,regDstC,rt,rd);
    Mux_5 regDist2(writeRegAdress,Jal,mux1Out, 5'b11111);
    Mux_32_2 aluSrc(in_alu2,aluSrcC,reg2Data,immediateValue32);
    Mux_32_2 memToReg(mux2Out, memToRegC, alu_output, data_memory_data);
    Mux_32_2 memToReg2(regFile_writeData, Jal, mux2Out, PC + 4);
    Mux_32_2 pcBranchMux(pcBranchOut, pcBranchSel, pcNewValue, branchRelativeValue);
    Mux_32_2 jumpBranchMux(PCwire, Jump, pcBranchOut, jump_label);
    
    SignExtend immediateValue(immediateValue32,imValue);

    assign OpCode = ins[31:26];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign shamt = ins[10:6];
    assign func = ins[5:0];
    assign imValue = {rd,shamt,func};
    assign pcBranchSel = zero & Branch;
    assign pcNewValue = PC + 4;
    assign jump_label = {PC[31:28],rs,rt,rd,shamt,func} << 2; // wrong
    assign branchRelativeValue = PC + 4  + (immediateValue32 << 2);

    always begin
        #5
        clk = ~clk;
    end

    always @(posedge clk) begin
	if(Jump) begin
		PC <= jump_label;
	end
	else if (Branch & zero) begin
		PC <= branchRelativeValue;
	end
	else if (BranchNot & (!zero)) begin
		PC <= branchRelativeValue;
	end
	else if (Jal) begin
		PC <= jump_label;
	end
	else if (JumpR) begin
		PC <= reg1Data;
	end
	else begin
        	PC <= PC + 4;
    	end
    end

endmodule


