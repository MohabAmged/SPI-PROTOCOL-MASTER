module Clk_controller (
    input  wire Sclk ,
    input  wire clk_en,
    input  wire CKP  ,
    input  wire CKE  , 
    output reg clk_out   
);

parameter IDEAL_ZERO_NORMAL_PHASE    = 2'b00;
parameter IDEAL_ONE_NORMAL_PHASE     = 2'b01;
parameter IDEAL_ZERO_INEVRTED_PHASE  = 2'b10;
parameter IDEAL_ONE_INVERTED_PHASE   = 2'b11;
parameter IDEAL = 1'b0 ;



always @(*) begin
    
    case ({CKE,CKP})
IDEAL_ZERO_NORMAL_PHASE      : clk_out = clk_en ?  Sclk:    IDEAL;
                                                
IDEAL_ONE_NORMAL_PHASE       : clk_out = clk_en ?  Sclk:   ~IDEAL;

IDEAL_ZERO_INEVRTED_PHASE    : clk_out = clk_en ? ~Sclk:   IDEAL;

IDEAL_ONE_INVERTED_PHASE     : clk_out = clk_en ? ~Sclk:  ~IDEAL;

        default: clk_out = Sclk | IDEAL; 

    endcase


end
    
endmodule