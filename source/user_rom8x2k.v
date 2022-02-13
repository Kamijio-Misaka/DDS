module user_rom8x2k #(parameter ROM_DEPTH = 11'd2047)(
	input  				clk_i  			,
    input  				clk_en_i		,

    //输入状态
	input		[2:0]	FSM_state		,
    input				nkey_wave_con	,
  	
    input  		[10:0]  addr_i  		,
    output reg  [7:0]  	rd_data_o
);

localparam	WAVEMODE = 3'b001, VPPMODE  = 3'b100;

reg [7:0]	sin_table [ROM_DEPTH:0];
reg	[7:0]	tri_table [ROM_DEPTH:0];
reg	[7:0]	squ_table [ROM_DEPTH:0];

initial begin
	$readmemb("C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/MAT/sin_data.txt",		sin_table);
	$readmemb("C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/MAT/triangle_data.txt",	tri_table);
	$readmemb("C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/MAT/square_data.txt",		squ_table);
end

/* 状态图 */
reg [1:0] state;
localparam SIN = 2'b00, TRIANGLE = 2'b01, SQUARE = 2'b11;

/* 波形状态转换 */
always @(posedge clk_i or negedge clk_en_i) begin
	if (~clk_en_i) begin
		state <= 2'b0;// reset
	end
	else if((FSM_state == WAVEMODE) && (nkey_wave_con == 1'b0)) begin
		case (state)
			SIN: 		state <= TRIANGLE 	;
			TRIANGLE:	state <= SQUARE 	;
			SQUARE:		state <= SIN 		;
			default:	state <= SIN 		;
		endcase
	end
	else 
		state <= state;
end

/* 不同状态输出不同波形 */
always @(posedge clk_i or negedge clk_en_i) begin
	if (~clk_en_i) begin
		rd_data_o <= 8'b0;// reset
	end
	else begin
		case (state)
			SIN: 		rd_data_o <= sin_table[addr_i][7:0];
			TRIANGLE:	rd_data_o <= tri_table[addr_i][7:0];
			SQUARE:		rd_data_o <= squ_table[addr_i][7:0];
			default:	rd_data_o <= sin_table[addr_i][7:0];
		endcase
	end
end

/* 输出幅度控制 */


endmodule