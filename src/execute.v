/* 执行和内存访问 */
`include "riscv_defines.v"

module kamikaze_execute(clk_i,
			rst_i,
			
			alu_op1_i,
			alu_op2_sel_i,
			alu_op2_i,
			alu_op2_imm_i,
			alu_func_i,
			pc_i,
			pc_o,
			
			/* 到回写阶段 */
			rf_rd_i,
			rf_rd_o,
			rf_rd_we_i,
			rf_rd_we_o,
			
			/* 输出 */
			result_o
			);
	input clk_i;
	input rst_i;
	
	input [31:0]alu_op1_i;/* 固定接寄存器 */
	input alu_op2_sel_i; /* 选择接寄存器还是立即数, 1 = 寄存器， 0 = 立即数 */
	input [31:0]alu_op2_i; /* 寄存器输入  */
	input [31:0]alu_op2_imm_i; /* 立即数输入 */
	input [2:0]alu_func_i; /* ALU 功能选择 */
	output reg [31:0] result_o; /* ALU 输出 */
	
	
	/* 到回写阶段 */
	input [4:0]rf_rd_i;
	output reg [4:0]rf_rd_o;
	
	input rf_rd_we_i;
	output reg rf_rd_we_o;
	
	
	input [31:0]pc_i;
	output [31:0] pc_o;
	
	reg [31:0] alu_out;
	
	reg [31:0] pc;
	
	
	
	assign pc_o = pc;
	
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			pc <= 0;
		end
		else
		begin
			pc <= pc_i;
			result_o <= alu_out;
			
			rf_rd_o <= rf_rd_i;
			rf_rd_we_o <= rf_rd_we_i;
		end
	end
	
	wire [31:0]alu_op2 = alu_op2_sel_i? alu_op2_i: alu_op2_imm_i;
	

	/* ALU */
	
	/* 加法器和减法器 */
	
	/* ALU选择逻辑 */
	always @*
	begin
		case (alu_func_i)
			`ALU_ADD:
				alu_out <= alu_op1_i + alu_op2;
			`ALU_XOR:
				alu_out <= alu_op1_i ^ alu_op2;
			`ALU_OR:
				alu_out <= alu_op1_i | alu_op2;
			`ALU_AND:
				alu_out <= alu_op1_i & alu_op2;
			default:
				alu_out <= 32'bx;
		endcase
				
	end
	



endmodule
