module clk_div (
    input logic clk,
    input logic rst,
    input [18:0] master,
    output logic clk_pix,
    output logic clk_pix_10x,
    output logic clk_pix_locked
);

    logic [18:0] MASTER_DIV;
    logic feedback;
    logic clk_pix_unbuf;
    logic clk_pix_10x_unbuf;
    logic locked;

    assign MASTER_DIV = master / 10000;

    MMCME2_BASE #(
        .CLKBOUT_MULT_F(MASTER_DIV),
        .CLKIN1_PERIOD(IN_PERIOD),
        .CLKOUT0_DIVIDE_F(DIV_10x),
        .CLKOUT1_DIVIDE_F(DIV_1X),
        .DIV_CLK_DIVIDE(DIV_MASTER)
    ) MMCME2_BASE_inst (
        .CLKIN1(clk),
        .RST(rst),
        .CLKOUT0(clk_pix_10x_unbuf),
        .CLKOUT1(clk_pix_unbuf),
        .LOCKED(locked),
        .CLKFBOUT(feedback),
        .CLKFBIN(feedback),
        .CLKOUT0B(),
        .CLKOUT1B(),
        .CLKOUT2B(),
        .CLKOUT3B(),
        .CLKOUT2(),
        .CLKOUT3(),
        .CLKOUT4(),
        .CLKOUT5(),
        .CLKOUT6(),
        .CLKFBOUTB(),
        .PWRDWN()
    );

    BUFG bufg_clk(.I(clk_pix_unbuf), .O(clk_pix));
    BUFG bufg_clk_10x(.I(clk_pix_10x_unbuf), .O(clk_pix_10x));

    logic locked_sync_0;
    always_ff @(posedge clk_pix) begin
        locked_sync_0 <= locked;
        clk_pix_locked<= locked_sync_0;
    end
endmodule
