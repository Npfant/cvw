module video_controller(
    input logic clk,
    input logic rst,
    input logic [1:0]  res,
    input logic [23:0] dataIn,
    output logic ch0,
    output logic ch1,
    output logic ch2,
    output logic chc
);

//localparam 640_length = 10;
//localparam 640_WIDTH = 640;
//localparam 640_HEIGHT = 480;
//localparam 640_totPix = 640_WIDTH * 640_HEIGHT;
//localparam 640_addrLength = $clog2(640_totPix);

//localparam 1280_length = 12;
localparam WIDTH = 1280;
localparam HEIGHT = 720;
localparam totPix = WIDTH * HEIGHT;
localparam addrLength = $clog2(totPix);

logic clk_pix, clk_10x, clk_pix_locked;
logic [11 : 0] sx, sy;
logic hsync, vsync;
logic de, we;
logic [23:0] buffIn;
logic [addrLength-1:0] writeAddr, readAddr;


if(res == 01) begin
   //Clock generator  
   clk_div #(.MASTER(37.125)) clk_gen(clk, rst, clk_pix, clk_10x, clk_pix_locked);
   //Generate screen position signals
   scrn_pos #(.res_swtch(1)) pos(clk_pix, rst, sx, sy, hsync, vsync, de);
end else begin
   clk_div #(.MASTER(12.5875)) clk_gen(clk, rst, clk_pix, clk_10x, clk_pix_locked);
   scrn_pos #(.res_swtch(0)) pos(clk_pix, rst, sx, sy, hsync, vsync, de);
end

always_ff @(posedge clk_pix) begin
    //Check resolution to determine bounds
    if(res == 2'b01) begin
        //Check to see if in the active region
        if(sx > 219) begin
            if(sx < 1500) begin
                if(sy > 19) begin
                    if(sy < 740) begin
                        we <= 1;
                    end else begin
                        we <= 0;
                    end
                end else begin
                    we <= 0;
                end
            end else begin
                we <= 0;
            end
        end else begin
            we <= 0;
        end
        //Calculate write address within the frame buffer
        writeAddr <= WIDTH * sy + sx;
        if(sx == 0 && sy == 0) begin
            readAddr <= 0;
        end else if (we) begin
            readAddr <= readAddr + 1;
        end
    end else begin
        if(sx > 47) begin
            if(sx < 688) begin
                if(sy > 32) begin
                    if(sy < 513) begin
                        we <= 1;
                    end else begin
                        we <= 0;
                    end
                end else begin
                    we <= 0;
                end
            end else begin
                we <= 0;
            end
        end else begin
            we <= 0;
        end
        //Calculate write address within the frame buffer
        writeAddr <= WIDTH * sy + sx;
        if(sx == 0 && sy == 0) begin
            readAddr <= 0;
        end else if (we) begin
            readAddr <= readAddr + 1;
        end
    end
end

//Framebuffer
vram framebuffer(clk_pix, clk_pix, we, writeAddr, readAddr, dataIn, buffIn);

//DVI encoder and generator
dvi_generator gen(clk_pix, clk_10x, rst, de, buffIn[7:0], {hsync, vsync}, buffIn[15:8], 2'b00, buffIn[23:16], 2'b00, ch0, ch1, ch2, chc);

endmodule
