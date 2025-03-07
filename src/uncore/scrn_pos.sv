module scrn_pos #(res_swtch = 0)(
    input logic clk_pix,
    input logic rst_pix,
    output logic [11:0] sx,
    output logic [11:0] sy,
    output logic hsync,
    output logic vsync,
    output logic de
);

    localparam H_ACT = (res_swtch == 2) ? 1279 : (res_swtch == 1) ? 1919 : 639;
    localparam H_FP = (res_swtch == 2) ? (H_ACT + 110) : (res_swtch == 1) ? (H_ACT + 88) : (H_ACT + 16);
    localparam H_S = (res_swtch == 2) ? (H_FP + 40) : (res_swtch == 1) ? (H_FP + 44) : (H_FP + 96);
    localparam H_TOT = (res_swtch == 2) ? 1649 : (res_swtch == 1) ? 2199 : 799;
    localparam V_ACT = (res_swtch == 2) ? 719 : (res_swtch == 1) ? 1079 : 479;
    localparam V_FP = (res_swtch == 2) ? (V_ACT + 5) : (res_swtch == 1) ? (V_ACT + 4) : (V_ACT + 2);
    localparam V_S = (res_swtch == 2) ? (V_FP + 5) : (res_swtch == 1) ? (V_FP + 5) : (V_FP + 2);
    localparam V_TOT = (res_swtch == 2) ? 749 : (res_swtch == 1) ? 1124 : 524;

    always_comb begin
        hsync = ~(sx >= H_FP && sx < H_S);
        vsync = ~(sy >= V_FP && sy < V_S);
        de = (sx <= H_ACT && sy <= V_ACT);
    end

    always_ff @(posedge clk_pix) begin
        if(sx == H_TOT) begin
            sx <= 0;
            sy <= (sy == V_TOT) ? 0 : sy + 1;
        end else begin
            sx <= sx + 1;
        end
        if (rst_pix) begin
            sx <= 0;
            sy <= 0;
        end
    end
endmodule