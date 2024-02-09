module CLK_CONTROL_tb ();
    

wire out ;
reg CKP,clk,CKE,clk_en;

parameter IDEAL_ZERO_NORMAL_PHASE    = 2'b00;
parameter IDEAL_ONE_NORMAL_PHASE     = 2'b01;
parameter IDEAL_ZERO_INEVRTED_PHASE  = 2'b10;
parameter IDEAL_ONE_INVERTED_PHASE   = 2'b11;


initial begin
    clk=0;
    forever begin
        #10 clk=~clk;
    end
end

initial begin
clk_en=0;
#100;

@(negedge clk)  begin
    
{ CKE,CKP } = IDEAL_ZERO_NORMAL_PHASE;

end

#200;
@(negedge clk)  begin
    
clk_en=1;

end

#200 ;
@(negedge clk)  begin
 clk_en=0;   
{ CKE,CKP } = IDEAL_ONE_NORMAL_PHASE ;

end

#200 ;
@(negedge clk)  begin
 clk_en=1;   
end


#200 ;
@(negedge clk)  begin
     clk_en=0;
{ CKE,CKP } = IDEAL_ZERO_INEVRTED_PHASE ;

end

#200 ;
@(negedge clk)  begin
     clk_en=1;

end


#200 ;
@(negedge clk)  begin
      clk_en=0;
{ CKE,CKP } = IDEAL_ONE_INVERTED_PHASE ;

end
#200 ;
@(negedge clk)  begin
      clk_en=1;

end





end

 Clk_controller  clk_inst(
    .clk (clk) ,
    .CKP (CKP) ,
    .clk_en(clk_en),
    .CKE (CKE) , 
    .clk_out(out)   
);





endmodule