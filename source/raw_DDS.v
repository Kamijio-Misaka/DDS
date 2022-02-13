module raw_DDS (
	input		iclk		,
	input		irst_n		,
	/* 按键 */
	input		ikey_sel_n	,
	input		ikey_fov_n	,

	/* ADC输入输出控制 */
	input		pwm_adc_in	,
	output	 	pwm_out		,
	
	output	[7:0]	owdac_num	
);
`define    NODEBUG

localparam	ROM_DEPTH = 11'd2047;

wire 	wpll_sys_clk; //PLL分频后时钟
wire 	wpll_glo_clk;
wire 	w_pll_lock;
wire 	w_sys_rstn;
	
wire 	ikey_sel_n_fin;
wire 	ikey_fov_n_fin;
wire 	[7:0] pwm_adc_out;

/* 根据按键选择调节状态 */
wire [2:0] FSM_state;
state_fsm state_fsm_inst(
	.clk		(wpll_sys_clk),
	.rst_n		(w_sys_rstn),

	.key_sel_n 	(ikey_sel_n_fin),

	.state 		(FSM_state)
);

/* PLL产生48MhZ时钟信号 */
pll_sys pll_sys_inst (
	.ref_clk_i		(iclk), 
	.rst_n_i		(irst_n), 
	.lock_o			(w_pll_lock), 
	.outcore_o		(wpll_sys_clk), 
	.outglobal_o	(wpll_glo_clk)
	);
assign w_sys_rstn = w_pll_lock & irst_n;


/* 累加器 */
wire [10:0] rrom_addr;	//累加器输出得地址
acculator #
(.OUTCNT_MAX	(ROM_DEPTH)	) acculator_inst
(	
	.iclk			(wpll_sys_clk),
	.irstn			(w_sys_rstn),
	//输入状态	
	.FSM_state		(FSM_state),
	.nkey_freq_con	(ikey_fov_n_fin),
	//输入adc数据
	.pwm_adc_out	(pwm_adc_out),
	
	.odac_adder		(rrom_addr)
);


/* rom存储波形数据表,根据按键选择的波形 */ 
/* 输出DAC信号 */
user_rom8x2k #(
	.ROM_DEPTH	(ROM_DEPTH)
)user_rom8x2k_inst
(
	.clk_i 			(wpll_sys_clk),
	.clk_en_i		(w_sys_rstn),
	
	//输入状态	
	.FSM_state		(FSM_state),
	.nkey_wave_con	(ikey_fov_n_fin),

	.addr_i			(rrom_addr),
	.rd_data_o		(owdac_num)
);

/**********************************************************/
/**********************************************************/
/************************* 按键消抖 ************************/
/**********************************************************/
/**********************************************************/
/* 波形选择按键消抖 */
key_filter #(
	
	`ifdef DEBUG
		.CNT_MAX	(21'd4)
	`else 
    	.CNT_MAX	(21'd1_199_999)
    `endif
)keysel_filter_inst_sel
(
    .clk     	(wpll_sys_clk),
    .rst_n   	(w_sys_rstn	),
    .key_in  	(ikey_sel_n),
	
    .key_flag	(ikey_sel_n_fin)
);

/* 频率选择按键消抖 */
key_filter #(
	
	`ifdef DEBUG
		.CNT_MAX	(21'd4)
	`else 
    	.CNT_MAX	(21'd499_999)
    `endif
)keyfreq_filter_inst_fov
(
    .clk     	(wpll_sys_clk),
    .rst_n   	(w_sys_rstn	),
    .key_in  	(ikey_fov_n),
	
    .key_flag	(ikey_fov_n_fin)
);
/**********************************************************/
/**********************************************************/
/************************* 按键消抖 ************************/
/**********************************************************/
/**********************************************************/

/* ADC */
pwm_adc pwm_adc_inst(
	.pwm_adc_in		(pwm_adc_in),
	.clk_i			(wpll_sys_clk),
	.rst_n_i		(w_sys_rstn),
	
	.pwm_out		(pwm_out),
	.pwm_adc_out	(pwm_adc_out)
);

endmodule
