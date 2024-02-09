module Spi_master_cotroller (
    input  wire clk  ,
    input  wire rst  ,
    input  wire START ,
    input  wire SCLK,
    input  wire CKP,
    input  wire CKE,   
    input  wire DATA_LOAD,
    output reg SH_EN ,
    output reg SH_ld ,
    output reg Sclk_En,
    output reg SH_unload ,
    output reg CS
                         
);

parameter RESET                = 2'b00 ;
parameter LOAD                 = 2'b01 ;
parameter SHIFT_ENABLE         = 2'b10 ;
parameter UNLOAD               = 2'b11 ;


reg COUNT_rst;
reg [3:0] count ;
reg [3:0] count_inv ;
reg [1:0] state ;
reg [1:0] Next_state ;


parameter IDEAL_ZERO_NORMAL_PHASE    = 2'b00;
parameter IDEAL_ONE_NORMAL_PHASE     = 2'b01;
parameter IDEAL_ZERO_INEVRTED_PHASE  = 2'b10;
parameter IDEAL_ONE_INVERTED_PHASE   = 2'b11;
parameter IDEAL = 1'b0 ;


  



always @(posedge clk ) begin
    if (rst) begin
    state<=RESET; 
    end
    else begin 
    state<=Next_state;
    end
    if (state == RESET) begin
        COUNT_rst<=1;
    end
    else COUNT_rst<=0;
    end


// NEGEDGE COUNT 
always @( COUNT_rst or negedge SCLK) begin
 
 if (COUNT_rst) begin
    count<=0;
 end
 
 if ( Next_state == SHIFT_ENABLE ) begin
        count<=count+1;
    if ( {CKE,CKP} ==IDEAL_ONE_NORMAL_PHASE) begin
            count<=1;
        end
    end 
    else
    count<=0;

    end


// POSEDGE COUNT  
always @( COUNT_rst or posedge SCLK) begin
 
 if (COUNT_rst) begin
    count_inv<=0;
 end
 
 if ( Next_state == SHIFT_ENABLE ) begin
        count_inv<=count_inv+1;
            if ({CKE,CKP} == IDEAL_ZERO_INEVRTED_PHASE) begin
            count_inv<=1;
        end
    end
    else 
    count_inv<=0;

    end



always @(*) begin
    
case (state)
    RESET:   
            begin
                SH_ld=0;
                Sclk_En=0;
                SH_unload=0;
                CS = 1 ;
                SH_EN   = 0;
                if(DATA_LOAD)
                Next_state=LOAD;
                else Next_state=RESET; 
            end

    LOAD:            
            begin

                SH_ld=1;
                Sclk_En=0;
                SH_unload=0;
                CS = 1;
                SH_EN   = 0; 
                if (START) begin
                     Next_state=SHIFT_ENABLE; 
                end
                else  Next_state=LOAD; 
                                                  
                        end
            
    SHIFT_ENABLE : 
            begin
                SH_ld=0;
                Sclk_En=1;
                SH_unload=0; 
                CS = 0;
                    case ({CKE,CKP})
                    IDEAL_ZERO_NORMAL_PHASE      :  begin 
                        SH_EN=1;
                        if (count == 8 )
                        begin
                           SH_EN=0; 
                        end
                  if ( count<=7 ) begin
                    Next_state=SHIFT_ENABLE;
                end                         
                else begin 
                    Next_state = UNLOAD;
                end 

                    end
                    IDEAL_ONE_NORMAL_PHASE       : 
                     begin 
                        if (count == 1) begin
                             SH_EN=1;
                        end
                        if (count_inv == 8 )
                        begin
                           SH_EN=0; 
                        end

                if ( count_inv<=8   ) begin
                    Next_state=SHIFT_ENABLE;
                end                         
                else begin 
                    Next_state = UNLOAD;
                end 
                    end

                    IDEAL_ZERO_INEVRTED_PHASE    : 
                        begin 
                            //if (count_inv == 1) begin
                                SH_EN=1;
                            //end
                        if (count == 8 )
                        begin
                           SH_EN=0; 
                        end
                if (count<=7  ) begin
                    Next_state=SHIFT_ENABLE;
                end                         
                else begin 
                    Next_state = UNLOAD;
                end 
                    end

                    IDEAL_ONE_INVERTED_PHASE     : 
                         begin 
                        if (count==1) begin
                            SH_EN=1;
                        end
                        if (count == 9 )
                        begin
                           SH_EN=0; 
                        end
                if ( count_inv<=8   ) begin
                    Next_state=SHIFT_ENABLE;
                end                         
                else begin 
                    Next_state = UNLOAD;
                end 
                    end
                    default:  SH_EN=0;

                        endcase
                             

             end  

    UNLOAD : 
            begin
                SH_ld=0;    
                Sclk_En=0;
                SH_unload=1; 
                CS=1;
                Next_state=RESET;
             end         
        default:  Next_state=RESET;

endcase


end 









    
endmodule