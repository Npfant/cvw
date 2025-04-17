//module differential(
//    input logic clk,
//    input logic rst,
//    input logic channel,
//    output logic channelp,
//    output logic channeln
//);

//always_ff @(posedge clk) begin
//    if(rst) begin
//        channelp <= 0;
//        channeln <= 0;
//    end else begin
//        channelp <= channel;
//        channeln <= ~channel;
//    end
//end

//endmodule

// Project F Library - XC7 TMDS Signal Output
// (C)2021 Will Green, Open source hardware released under the MIT License
// Learn more at https://projectf.iox   

// OBUFDS is documented in Xilinx UG471

module differential (
    input       logic I,     // TMDS signal
    output      logic O,    // positive differential signal pin
    output      logic OB     // negative differential signal pin
    );

OBUFDS #(
   .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
   .SLEW("SLOW")           // Specify the output slew rate
) OBUFDS_inst (
   .O(O),     // Diff_p output (connect directly to top-level port)
   .OB(OB),   // Diff_n output (connect directly to top-level port)
   .I(I)      // Buffer input
);

// End of OBUFDS_inst instantiation

endmodule
