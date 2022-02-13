module key_filter
#(
    parameter CNT_MAX = 21'd499_999
)
(
    input wire      clk     ,
    input wire      rst_n   ,
    input wire      key_in  ,

    output reg      key_flag
);

    reg [19:0]  cnt;
    
    /* 若按键有效，则开启级数 */
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            cnt <= 20'd0;
        else if (key_in == 1'b1) 
            cnt <= 20'd0;
        else if (cnt == CNT_MAX) 
            cnt <= CNT_MAX;
        else
            cnt <= cnt + 20'd1;
    end
    

    /* 抖动结束出现按键标志位 */
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            key_flag <= 1'd1;
        else if (cnt == (CNT_MAX -1) )
            key_flag <= 1'd0;
        else
            key_flag <= 1'd1;
    end 


endmodule
