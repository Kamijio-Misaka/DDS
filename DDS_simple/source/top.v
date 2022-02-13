module top(
	input			iclk		,
	input			irstn		,

	/* 按键 */
	input			ikey_sel_n	,
	input			ikey_fov_n	,

	/* ADC输入输出控制 */
	input			pwm_adc_in	,
	output	 		pwm_out		,
	
	output	[7:0]	owdac_num	,

	output			oled_csn	,	//OLCD液晶屏使能
	output			oled_rst	,	//OLCD液晶屏复位
	output			oled_dcn	,	//OLCD数据指令控制
	output			oled_clk	,	//OLCD时钟信号
	output			oled_dat		//OLCD数据信号

	);
	
	raw_DDS  raw_DDS_inst (
	.iclk		(iclk),
	.irst_n		(irstn),

	/* 按键 */
	.ikey_sel_n	(ikey_sel_n),
	.ikey_fov_n	(ikey_fov_n),
	
	/* ADC输入输出控制 */
	.pwm_adc_in	(pwm_adc_in),
	.pwm_out	(pwm_out),

	.owdac_num	(owdac_num)
	);


	/* 显示模块 */
	wire pll_clk;
	wire pll_rst_n;
	assign pll_clk = raw_DDS_inst.wpll_sys_clk;
	assign pll_rst_n = raw_DDS_inst.w_sys_rstn;
	wire [2:0] FSM_state;
	assign FSM_state = raw_DDS_inst.FSM_state;
	wire [1:0] shape;
	assign shape = raw_DDS_inst.user_rom8x2k_inst.state;
	wire [23:0] freq;
	assign freq = raw_DDS_inst.acculator_inst.freq_byte;
	wire [23:0] freq_num;
	assign freq_num = ((freq*4'b1011)>>2);
	wire [2:0] freq_state;
	assign freq_state = raw_DDS_inst.acculator_inst.freq_conf_state;
	wire [7:0] vpp_byte;
	assign vpp_byte = raw_DDS_inst.user_rom8x2k_inst.adc_val_reg;
	wire [23:0] vpp;
	assign vpp = 3300 * vpp_byte;
	OLED12864 OLED12864_inst (
			.clk  			(pll_clk),	//12MHz系统时钟
			.rst_n 			(pll_rst_n),	//系统复位，低有效

			.FSM_state		(FSM_state),
		
			.vpp			(vpp[23:8]),
			.frq			(freq_num[15:0]),
			.shape 			(shape),
			.freq_sta 		(freq_state),

			.oled_csn		(oled_csn),	//OLCD液晶屏使能
			.oled_rst		(oled_rst),	//OLCD液晶屏复位
			.oled_dcn		(oled_dcn),	//OLCD数据指令控制
			.oled_clk		(oled_clk),	//OLCD时钟信号
			.oled_dat		(oled_dat)	//OLCD数据信号
		);


endmodule