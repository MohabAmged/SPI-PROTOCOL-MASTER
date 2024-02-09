
module SPI_Master_Top  (
    input   wire clk ,
    input   wire rst ,
    input   reg [7:0] Divisor ,
    input   wire LD_DIV,
    input   reg [7:0] data_TX ,
    input   wire START,
    input   wire DATA_LOAD,
    input   wire CKP,
    input   wire CKE,
    input   wire MISO,
    output  wire SCLK,
    output  wire MOSI,
    output  wire CS,
    output  wire [7:0]data_RX 

    
);

    // SHIFT REGISTER WIRES 
    wire SH_EN;
    wire SH_LD;
    wire SH_UNLOAD;

    // CLOCK & CLOCK CONTROLLER WIRES
    wire SCLK_EN ;
    wire CLk_GEN;
    //wire CLK_GEN_BAR;
    //wire CLK_GEN_NORMAL;

    //assign CLk_GEN = CKE? CLK_GEN_BAR:CLK_GEN_NORMAL;





    // Spi_Controller MASTER
   Spi_master_cotroller Master_controller_inst ( 
    . clk(clk)  ,
    . rst(rst)  ,
    . SCLK(SCLK),
    . SH_EN(SH_EN) ,
    . SH_ld (SH_LD),
    . Sclk_En(SCLK_EN),
    . START(START),
    . DATA_LOAD(DATA_LOAD) ,
    . SH_unload(SH_UNLOAD)  ,
    . CKP(CKP),
    . CKE(CKE),
    . CS (CS)        
   ) ;


    // clock controller 
Clk_controller CLK_CONT_INST (
    . Sclk(CLk_GEN)  , 
    . clk_en(SCLK_EN) ,
    . CKP(CKP)   , 
    . CKE (CKE)  ,  
    . clk_out (SCLK)   
       );


    // clock Gen 
clock_Gen CLOCK_GEN_INST (
     .clk(clk) ,
     .divisor(Divisor) ,
     .ld_divisor(LD_DIV)    ,
     .rst(rst) ,
     .En(1'b1),
     //.out_clk_bar(CLK_GEN_BAR),
    . out_clk (CLk_GEN)  
);

    // Shift Reg 
    Shift_reg_8bits SHIFT_REG_INST (
    .      data (data_TX)  ,
    .      RW_clock(clk),
    .      Ld (SH_LD)   ,
    .      clk (SCLK)   ,
    .      in (MISO)   ,
    .      en (SH_EN)   ,
    .      rst(rst)     ,
    .      CKE(CKE)    ,
    .      CKP(CKP)    ,
    .      un_ld (SH_UNLOAD) ,    
    .      out(MOSI)   ,
    .      data_out(data_RX)  

    );



    
endmodule