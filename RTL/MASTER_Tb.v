module MASTER_TB (); 
    reg clk ;
    reg rst ;
    reg [7:0] Div ;
    reg [7:0] data_TX ;
        
        wire [7:0] data_SHIFTER ;
    
    reg  CKP;
    reg  CKE;
    wire  MISO;
    reg  START;
    wire SCLK;
    wire MOSI;
    wire CS;
    reg DATA_LOAD;
    wire [7:0 ]data_RX ;
    reg LD_DIV;
    reg [7:0] data_SHIFT; 

parameter IDEAL_ZERO_NORMAL_PHASE    = 2'b00;
parameter IDEAL_ONE_NORMAL_PHASE     = 2'b01;
parameter IDEAL_ZERO_INEVRTED_PHASE  = 2'b10;
parameter IDEAL_ONE_INVERTED_PHASE   = 2'b11;

  task expect (input [7:0]value , input [7:0]shifter);
    if (data_RX === value && data_SHIFTER === shifter ) begin
        $display("TEST PASSED");
        $display("---------------------------------------------------------------------------------------------------------------------");
        $display("time=%0d:\nDATA_RECIEVED is %x and should be %x : DATA_sent is %x and should be %x:\nCKP is %b: CKE is %b ",
                 $time, data_RX, value,data_SHIFTER,shifter,CKP,CKE);
        case ({CKE,CKP})
           IDEAL_ZERO_NORMAL_PHASE : $display("Mode of Operation is IDEAL_ZERO_NORMAL_PHASE : Data sampled on rising edge and shifted out on the falling edge  ");
           IDEAL_ONE_NORMAL_PHASE  : $display("Mode of Operation is IDEAL_ONE_NORMAL_PHASE : Data sampled on falling edge and shifted out on the rising edge  ");
           IDEAL_ZERO_INEVRTED_PHASE  : $display("Mode of Operation is IDEAL_ZERO_INEVRTED_PHASE : Data sampled on falling edge and shifted out on the rising edge  ");            
           IDEAL_ONE_INVERTED_PHASE : $display("Mode of Operation is IDEAL_ONE_INVERTED_PHASE : Data sampled on rising edge and shifted out on the falling edge  ");
        endcase
      end  
      
      else begin
            $display("TEST FAIL");
            $display("---------------------------------------------------------------------------------------------------------------------");
        $display("time=%0d:\nDATA_RECIEVED is %x and should be %x : DATA_sent is %x and should be %x:\n CKP is %b: CKE is %b ",
                 $time, data_RX, value,data_SHIFTER,shifter,CKP,CKE);
             case ({CKE,CKP})
           IDEAL_ZERO_NORMAL_PHASE : $display("Mode of Operation is IDEAL_ZERO_NORMAL_PHASE : Data sampled on rising edge and shifted out on the falling edge  ");
           IDEAL_ONE_NORMAL_PHASE  : $display("Mode of Operation is IDEAL_ONE_NORMAL_PHASE : Data sampled on falling edge and shifted out on the rising edge  ");
           IDEAL_ZERO_INEVRTED_PHASE  : $display("Mode of Operation is IDEAL_ZERO_INEVRTED_PHASE : Data sampled on falling edge and shifted out on the rising edge  ");            
           IDEAL_ONE_INVERTED_PHASE : $display("Mode of Operation is IDEAL_ONE_INVERTED_PHASE : Data sampled on rising edge and shifted out on the falling edge  ");
        endcase
                  $stop;
      end

     
  endtask

SPI_Master_Top TOP_INST (
    . clk(clk) ,
    . rst(rst) ,
    . Divisor(Div) ,
    . data_TX(data_TX) ,
    . CKP(CKP),
    . CKE(CKE),
    . MISO(MISO),
    . SCLK(SCLK),
    . MOSI(MOSI),
    . START(START),
    . DATA_LOAD(DATA_LOAD),
    . CS(CS),
    . LD_DIV(LD_DIV),
    . data_RX(data_RX) 

);

 Shift_reg_8bits shift_TEST (
    .data(data_SHIFT)  ,
    .RW_clock(clk),
    .Ld(TOP_INST.SH_LD)    ,
    .clk(SCLK)   ,
    .in (MOSI)   ,
    .en (TOP_INST.SH_EN)   ,
    .rst(rst)   ,
    .un_ld(TOP_INST.SH_UNLOAD) ,    
    . out(MISO)   ,
    . CKP(CKP),   
    . CKE(CKE),
    . data_out(data_SHIFTER)     
);


initial begin
    clk=0;
    forever begin
        #10 ;
        clk = ~clk ;
    end
end


initial begin
    START=0;
    rst = 1;
    #100 ; 
    rst = 0;
    #100;
    @( negedge clk ) begin
    LD_DIV=1;
    Div=4;
    DATA_LOAD=1;
    data_TX =8'hf8;
    data_SHIFT=8'hc3;
    CKP = 0;
    CKE = 0; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;
    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0;  
        end  
    #50 ;
    expect(8'hc3,8'hf8);    

    #1000;


    rst = 1;
    #100 ; 
    rst = 0;
    #100;

    @( negedge clk ) begin
    LD_DIV=1;
    Div=4;
    DATA_LOAD=1;    
    data_TX =8'h3E;
    data_SHIFT=8'h6c;
    CKP = 1;
    CKE = 0; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;   

    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0; 

        end
        #50 ;
         expect(8'h6c,8'h3E);  

    #1000;


    rst = 1;
    #100 ; 
    rst = 0;
    #100;

    @( negedge clk ) begin
    LD_DIV=1;
    Div=4;
    DATA_LOAD=1;    
    data_TX =8'haa;
    data_SHIFT=8'h55;
    CKP = 0;
    CKE = 1; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;   

    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0; 
 
        end

        #50 ;
         expect(8'h55,8'haa); 



    #1000;
    rst = 1;
    #100 ; 
    rst = 0;
    #100;



    @( negedge clk ) begin
    LD_DIV=1;
    Div=4;
    DATA_LOAD=1;    
    data_TX =8'hFE;
    data_SHIFT=8'h26;
    CKP = 1;
    CKE = 1; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;   

    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0; 
  
        end
        #50
         expect(8'h26,8'hFE);



    #1000;
    rst = 1;
    #100 ; 
    rst = 0;
    #100;


    @( negedge clk ) begin
    LD_DIV=1;
    Div=4;
    DATA_LOAD=1;    
    data_TX =8'h34;
    data_SHIFT=8'h07;
    CKP = 0;
    CKE = 1; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;   

    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0; 
  
        end
        #50
         expect(8'h07,8'h34);


    #1000;
    rst = 1;
    #100 ; 
    rst = 0;
    #100;

    @( negedge clk ) begin
    LD_DIV=1;
    Div=8;
    DATA_LOAD=1;    
    data_TX =8'h00;
    data_SHIFT=8'hFF;
    CKP = 1;
    CKE = 1; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;   

    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0; 
  
        end
        #50
         expect(8'hFF,8'h00);


    #1000;
    rst = 1;
    #100 ; 
    rst = 0;
    #100;

    @( negedge clk ) begin
    LD_DIV=1;
    Div=8;
    DATA_LOAD=1;    
    data_TX =8'hEF;
    data_SHIFT=8'hEC;
    CKP = 1;
    CKE = 0; 
    end

    @( posedge clk )
    @( negedge clk )
    LD_DIV=0;
    DATA_LOAD=0;   

    #100 ; 
    START=1;

    @(posedge CS) 
        begin
         START = 0; 
  
        end
        #50
         expect(8'hEC,8'hEF);




$stop ;

end



endmodule