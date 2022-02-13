module acculator #(parameter OUTCNT_MAX = 11'd2047)
(
	input			iclk			,
	input			irstn			,
	//输入状态
	input	[2:0]	FSM_state		,
	//频率字高低位控制
	input			nkey_freq_con	,

	input 	[7:0]	pwm_adc_out		,

	output reg	[10:0]	odac_adder	

);
	localparam	FREQMODE = 3'b010;
	localparam	FREQ_CONF_L = 2'b00,FREQ_CONF_M = 2'b01,FREQ_CONF_H = 2'b11;
	reg	[2:0]	freq_conf_state;

	/* 频率大小段控制--状态机 */
	always @(posedge iclk or negedge irstn) begin
		if (~irstn)
			freq_conf_state <= FREQ_CONF_L;
		else if((FSM_state == FREQMODE) && (~nkey_freq_con)) begin
			case (freq_conf_state)
				FREQ_CONF_L: freq_conf_state <= FREQ_CONF_M;
				FREQ_CONF_M: freq_conf_state <= FREQ_CONF_H;
				FREQ_CONF_H: freq_conf_state <= FREQ_CONF_L;
				default: 	freq_conf_state <= FREQ_CONF_L;
			endcase
		end
		else 
			freq_conf_state <= freq_conf_state;
	end

	/* 频率控制 */
	reg	[23:0]	 freq_byte;
	always @(posedge iclk or negedge irstn) begin
		if (~irstn)
			freq_byte <= 1'b1;
		else if(FSM_state == FREQMODE) begin
			case (freq_conf_state)
				FREQ_CONF_L	: freq_byte[7 : 0] <= pwm_adc_out;
				FREQ_CONF_M	: freq_byte[13: 8] <= pwm_adc_out;
				FREQ_CONF_H	: freq_byte[23:16] <= pwm_adc_out;
				default		: freq_byte[7 : 0] <= pwm_adc_out;
			endcase
		end
		else
			freq_byte <= freq_byte;
	end

	/* 输出累加地址 */
	always @(posedge iclk or negedge irstn) begin
		if (~irstn)
			odac_adder <= 1'b0;
		else if(odac_adder == OUTCNT_MAX)
			odac_adder <= 1'd0;
		else
			odac_adder <= odac_adder + freq_byte[23:13];
	end


endmodule