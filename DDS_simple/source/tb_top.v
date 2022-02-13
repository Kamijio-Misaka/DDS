`timescale 1ns/10ps
module tb_top ();

reg clk;
reg rstn;
reg ikey_sel_n;

wire	[7:0]	owdac_num;

initial begin
	clk = 1'b0;
	rstn <= 1'b0;
	#25
	rstn <= 1'b1;
end

/* 获取PLL时钟 */
wire pll_clk;
wire pll_rst;
assign pll_clk = top_inst.raw_DDS_inst.wpll_sys_clk	;
assign pll_rst = top_inst.raw_DDS_inst.w_sys_rstn	;
/* 计数器 */
parameter CNT_MAX = 11'd2047;
reg [10:0] cnt;
always @(posedge pll_clk or negedge pll_rst) begin
	if (~pll_rst)
		cnt <= 1'b0;
	else if (cnt == CNT_MAX) 
		cnt <= 1'b0;
	else
		cnt <= cnt + 1'b1;
end


parameter	CNT_KEYCONTINUE = 5'd9;
reg [7:0] cnt_con;
reg flag;
always @(posedge pll_clk or negedge pll_rst) begin
	if (~pll_rst)
		flag <= 1'b0;
	else if (cnt == CNT_MAX) 
		flag <= 1'b1;
	else if (cnt_con == CNT_KEYCONTINUE)
		flag <= 1'b0;
	else
		flag <= flag;
end

always @(posedge pll_clk or negedge pll_rst) begin
	if (~pll_rst)
		cnt_con <= 1'b0;
	else if (cnt_con == CNT_KEYCONTINUE)
		cnt_con <= 1'b0; 
	else if (flag) 
		cnt_con <= cnt_con + 1'b1;
	else
		cnt_con <= 1'b0;
end

/* 更换按键 */
always @(posedge pll_clk or negedge pll_rst) begin
	if (~pll_rst)
		ikey_sel_n <= 1'b1;
	else if (flag) 
		ikey_sel_n <= 1'b0;
	else
		ikey_sel_n <= 1'b1;
end


always #42 clk = ~clk;

top  top_inst(
	.iclk		(clk),
	.irstn		(rstn),

	/* 按键 */
	.ikey_sel_n	(ikey_sel_n),
	
	/* ADC输入输出控制 */
	.owdac_num	(owdac_num)
);

endmodule