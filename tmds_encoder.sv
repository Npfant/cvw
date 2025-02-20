module tmds_encoder(
    input logic clk,
    input logic rst,
    input logic [7:0] data,
    input logic [1:0] ctrl,
    input logic de,
    output logic [9:0] tmds
);

logic [3:0] d_ones;
logic nor_xor;
logic [8:0] stage_1;

assign d_ones = {3'b0, data[0]} + {3'b0, data[1]} + {3'b0, data[2]} + {3'b0, data[3]} + {3'b0, data[4]} + {3'b0, data[5]} + {3'b0, data[6]} + {3'b0, data[7]};
assign nor_xor = (d_ones > 4'd4) || ((d_ones == 4'd4) && (data[0] == 0));

assign stage_1[0] = data[0];
assign stage_1[1] = (nor_xor) ? (stage_1[0] ~^ data[1]) : (stage_1[0] ^ data[1]);
assign stage_1[2] = (nor_xor) ? (stage_1[1] ~^ data[2]) : (stage_1[1] ^ data[2]);
assign stage_1[3] = (nor_xor) ? (stage_1[2] ~^ data[3]) : (stage_1[2] ^ data[3]);
assign stage_1[4] = (nor_xor) ? (stage_1[3] ~^ data[4]) : (stage_1[3] ^ data[4]);
assign stage_1[5] = (nor_xor) ? (stage_1[4] ~^ data[5]) : (stage_1[4] ^ data[5]);
assign stage_1[6] = (nor_xor) ? (stage_1[5] ~^ data[6]) : (stage_1[5] ^ data[6]);
assign stage_1[7] = (nor_xor) ? (stage_1[6] ~^ data[7]) : (stage_1[6] ^ data[7]);
assign stage_1[8] = (nor_xor) ? 0 : 1;

logic signed [4:0] ones;
logic signed [4:0] zeros;
logic signed [4:0] balance;
logic signed [4:0] bias;

assign ones = {4'b0, stage_1[0]} + {4'b0, stage_1[1]} + {4'b0, stage_1[2]} + {4'b0, stage_1[3]} + {4'b0, stage_1[4]} + {4'b0, stage_1[5]} + {4'b0, stage_1[6]} + {4'b0, stage_1[7]};
assign zeros = 5'b01000 - ones;
assign balance = ones - zeros;

always @ (posedge clk) begin
    if(rst) begin
        tmds <= 10'b1101010100;
        bias <= 5'sb00000;
    end else if (de == 0) begin
        case(ctrl)
            2'b00: tmds <= 10'b1101010100;
            2'b01: tmds <= 10'b0010101011;
            2'b10: tmds <= 10'b0101010100;
            default: tmds <= 10'b1010101011;
        endcase
        bias <= 5'sb00000;
    end else begin
        if (bias == 0 || balance == 0) begin
            if (stage_1[8] == 0) begin
                tmds[9:0] <= {2'b10, ~stage_1[7:0]};
                bias <= bias - balance;
            end else begin
                tmds[9:0] <= {2'b01, stage_1[7:0]};
                bias <= bias + balance;
            end
        end else if ((bias > 0 && balance > 0) || (bias < 0 && balance < 0)) begin
            tmds[9:0] <= {1'b1, stage_1[8], ~stage_1[7:0]};
            bias <= bias + {3'b0, stage_1[8], 1'b0} - balance;
        end else begin
            tmds[9:0] <= {1'b0, stage_1[8:0]};
            bias <= bias - {3'b0, ~stage_1[8], 1'b0} + balance;
        end
    end
end
endmodule
                
            
