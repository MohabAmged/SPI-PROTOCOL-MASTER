module Shift_reg_8bits (
    input   wire [7:0]data  ,
    input   wire      RW_clock,
    input   wire      Ld     ,
    input   wire      clk    ,
    input   wire      in     ,
    input   wire      en     ,
    input   wire      rst    ,
    input   wire      un_ld  ,  
    input   wire      CKP    ,
    input   wire      CKE    ,
    output  wire      out    ,
    output  reg [7:0] data_out     
);
    
reg [7:0] Shift_reg;
reg [7:0] Shift_reg_INVERTED_POLARITY;

reg in_bit;
reg in_bit_INV;

reg flag ;



assign out = (!CKP  && !CKE) || (CKP  && CKE) ?Shift_reg[7]:Shift_reg_INVERTED_POLARITY[7];



always @(rst or posedge RW_clock ) begin
        if (rst) begin
        data_out <= 8'h00;
        
        end
        if(Ld)begin
        Shift_reg<=data;
        Shift_reg_INVERTED_POLARITY<=data;
            
        end    
        else if (un_ld && ( (!CKP  && !CKE) || (CKP  && CKE) ) ) begin   
            data_out<=Shift_reg ;
        end
        else if(un_ld && ( (CKP  && !CKE) || (!CKP  && CKE) )) begin
            data_out<=Shift_reg_INVERTED_POLARITY ;
        end 



end



always @( rst or negedge clk) begin

    if (rst) begin
             Shift_reg<=8'h00;
        end

if ( en && ( (!CKP  && !CKE) || (CKP  && CKE) ) ) begin
       
        Shift_reg<={Shift_reg[6:0],in_bit};

end 
     
end


always @( rst or posedge clk) begin
        if (rst) begin
            in_bit<=0;
        end
    if (en && ( (!CKP  && !CKE) || (CKP  && CKE) ) ) begin
       in_bit <= in;
   end

end


// Sample on the neg edge  REG 
always @(  rst or posedge clk) begin
    if (rst) begin
             Shift_reg_INVERTED_POLARITY<=8'h00;
        end
if ( en &&  ( (CKP  && !CKE) || ((!CKP  && CKE) && flag) ) ) begin

      Shift_reg_INVERTED_POLARITY<= {Shift_reg_INVERTED_POLARITY[6:0],in_bit_INV};

end

if (en && ( (!CKP  && CKE) || (CKP  && !CKE) )&& !flag) begin
    Shift_reg_INVERTED_POLARITY<= {Shift_reg_INVERTED_POLARITY[6:0],in};
end

end


always @( rst or negedge clk) begin
   if (rst) begin
             in_bit_INV<=0;
             flag<=0;
        end
   
    if (en && ( (CKP  && !CKE) || (!CKP  && CKE) )  ) begin
       in_bit_INV<=in;
       flag<=1;
    end
       
   

end




endmodule



