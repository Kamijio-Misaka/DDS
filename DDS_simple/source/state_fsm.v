module state_fsm(
	input			clk			,
	input			rst_n		,

	input			key_sel_n	,

	output	[2:0]	state 		

);

	localparam	WAVEMODE = 3'b001, FREQMODE = 3'b010, VPPMODE  = 3'b100;
	reg [2:0] fsm_state;
					
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			// reset
			fsm_state <= WAVEMODE;
		end
		else if (~key_sel_n) begin
			case (fsm_state)
				WAVEMODE: fsm_state <= FREQMODE	;
				FREQMODE: fsm_state <= VPPMODE	;
				VPPMODE	: fsm_state <= WAVEMODE	;
				default	: fsm_state <= WAVEMODE	;
			endcase
		end
		else 
			fsm_state <= fsm_state;
	end

	assign state = fsm_state;


endmodule