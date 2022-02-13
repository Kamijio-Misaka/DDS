module pwm_adc(
	input				pwm_adc_in	,
	input				clk_i		,
	input				rst_n_i		,
			
	output	 	 		pwm_out		,
	output	reg [7:0]	pwm_adc_out	

);

reg r_adc_in;//Thought the D-reg to get the buffer I/O level.
always@(posedge clk_i or negedge rst_n_i)begin
	if(!rst_n_i)begin
		r_adc_in <= 1'b0;
	end else begin
		r_adc_in <= pwm_adc_in;
	end
end

wire adc_in_fall;//When the pwm_adc_in is falling,the adc_in_fall will output high.
assign adc_in_fall = (r_adc_in | pwm_adc_in)&(pwm_adc_in == 1'b0);

//-----The pwm generation-----
reg [7:0] pwm_adder;
reg pwm_adder_overflow; //Complete a counter and generate the overflow(one clock period)
always@(posedge clk_i or negedge rst_n_i)begin
	if(!rst_n_i)begin
		pwm_adder <= 8'd0;
		pwm_adder_overflow <= 1'b0;
	end else if(pwm_adder == 8'hff) begin
		pwm_adder <= pwm_adder + 1'b1;
		pwm_adder_overflow <= 1'b1;
	end else begin
		pwm_adder <= pwm_adder + 1'b1;
		pwm_adder_overflow <= 1'b0;
	end
end

reg [7:0] pwm_set;
always@(posedge clk_i or negedge rst_n_i)begin
	if(!rst_n_i)begin
		pwm_set <= 8'd0;
	end else if(adc_in_fall == 1'b1)begin
		pwm_adc_out <= pwm_set;
		pwm_set <= 8'd0;
	end else if(pwm_adder_overflow == 1'b1 && pwm_adc_in == 1'b0)begin
		pwm_set <= pwm_set;
	end else if(pwm_adder_overflow == 1'b1 && pwm_adc_in == 1'b1)begin
		pwm_set <= pwm_set + 1'b1;
	end
end

assign pwm_out = (pwm_adder <= pwm_set) ? 1'b1 : 1'b0;

endmodule