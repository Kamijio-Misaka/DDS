module pwm_adc(
	input				pwm_adc_in	,
	input				clk_i		,
	input				rst_n_i		,
			
	output	reg 		pwm_out		,
	output	reg [7:0]	pwm_adc_out	

);

/* 输入缓冲 */
reg adc_in_reg;
always @(posedge clk_i or negedge rst_n_i) begin
	if (~rst_n_i) 
		adc_in_reg <= 1'b0;
	else 
		adc_in_reg <= pwm_adc_in;
end

/* 下降沿检测 */
wire falling_edge_flag;
assign falling_edge_flag = adc_in_reg & (~pwm_adc_in);

/* 输出pwm占空比设置 */
reg [7:0] cnt;
always @(posedge clk_i or negedge rst_n_i) begin
	if (~rst_n_i) 
		cnt <= 1'b0;
	else if (cnt == 8'hff)
		cnt <= 1'b0;
	else 
		cnt <= cnt+8'b1;
end

reg [7:0] pwm_set;
always @(posedge clk_i or negedge rst_n_i) begin
	if (~rst_n_i) 
		pwm_set <= 1'b0;
	else if (cnt == 8'hff)
		pwm_set <= pwm_set +1'b1;
	else 
		pwm_set <= pwm_set;
end

/* pwm输出设置 */
always @(posedge clk_i or negedge rst_n_i) begin
	if (~rst_n_i) 
		pwm_out <= 1'b1;
	else if (falling_edge_flag)
		pwm_out <= 1'b0;
	else if (cnt < pwm_set)
		pwm_out <= 1'b1;
	else 
		pwm_out <= 1'b0;
end

/* 获取数据 */
always @(posedge clk_i or negedge rst_n_i) begin
	if (~rst_n_i) 
		pwm_adc_out <= 8'b0;
	else if (falling_edge_flag)
		pwm_adc_out <= pwm_set;
	else 
		pwm_adc_out <= pwm_adc_out;
end

endmodule