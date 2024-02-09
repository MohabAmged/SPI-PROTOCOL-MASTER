module Shift_reg_tb ();
    

wire out ;
wire [7:0] D_out;
wire [7:0] D_out2;
reg  [7:0] D_in;
reg ld ,clk,en,rst,un_ld;
integer count =0;
wire in;

initial begin
    clk=0;
    forever begin
        #10 clk=~clk;
    end
end

initial begin
    //in <=0;
    rst<=1;
    #50;
    rst<=0;
    #50;
    @(negedge clk ) begin
        D_in<=8'h8E;
        ld<=1;
        //in<=1;
    end
    @(posedge clk) begin
        #3;
        ld<=0;
        D_in<=8'h11;
    end

        en <= 1;

   for ( count=0 ;count<8 ;count=count+1 ) begin
     @(posedge clk ) begin
        #3;
     end
    end

    @(negedge clk )
    begin
    en<=0;
        ld<=0;
        un_ld<=0;
    end
        #100 un_ld<=1;
     
    /*
    @(negedge clk )
    begin
        en<=0;
        ld<=1;
    end
        @(posedge clk )
    begin
        #3
        en<=0;
        ld<=0;
    end
    */


end

 Shift_reg_8bits Shift_reg_inst (
    .data(D_in) ,
    .Ld(ld)   ,
    .clk(clk)  ,
    .in(in)   ,
    .en(en)   ,     
    .out(out)   ,
    .data_out(D_out) ,
    .un_ld(un_ld),
    .rst(rst)    
);

 Shift_reg_8bits Shift_reg_inst_2 (
    .data(8'hFF) ,
    .Ld(ld)   ,
    .clk(clk)  ,
    .in(out)   ,
    .en(en)   ,     
    .out(in)   ,
    .data_out(D_out2) ,
    .un_ld(un_ld),
    .rst(rst)    
);




endmodule