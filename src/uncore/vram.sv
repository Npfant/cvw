module vram (writeClk,readClk,writeEn,readEn,writePointer,readPointer,dataIn,dataOut);
input writeClk,readClk,writeEn,readEn;
input [19:0] writePointer,readPointer;
input [23:0] dataIn;
output [23:0] dataOut;
reg [23:0] buffMem [50000-1:0];
reg [23:0] dataOut;

always @(posedge writeClk)
    begin
    if (writeEn)
        begin
            buffMem[writePointer] <= dataIn;
        end
    end
always @(posedge readClk)
    begin
    if (readEn)
        begin
        dataOut <= buffMem[readPointer-1];
        end
    end
endmodule
