module Clock_gen_tb ();
    

wire out_clk ;
reg [7:0] divisor;
reg  ld_div;
reg En;
reg clk,rst;


initial begin
    clk=0;
    forever begin
        #10 clk=~clk;
    end
end

initial begin
    rst<=1;
    En<=0;
    #50;
    rst<=0;
    #50;
    @(negedge clk ) begin
        ld_div<=1;
        divisor<=8'h04;
    end
    @(posedge clk) begin
        #3;
        ld_div<=0;
        divisor<=8'hff;
        En<=1;
    end
    #1000;
    En<=0;
    rst<=1;
    #50;
    rst<=0;
    #50;
    @(negedge clk ) begin
        ld_div<=1;
        divisor<=8'h02;
    end
    @(posedge clk) begin
        #3;
        En<=1;
        ld_div<=0;
        divisor<=8'hff;
    end
    #1000;
    En<=0;
    rst<=1;
    #50;
    rst<=0;
    #50;
    @(negedge clk ) begin
        ld_div<=1;
        divisor<=8'h05;
    end
    @(posedge clk) begin
        #3;
        En<=1;
        ld_div<=0;
        divisor<=8'hff;
    end
    #1000;
    rst<=1;
    En<=0;
    #50;
    rst<=0;
    #50;  
    @(negedge clk ) begin
        ld_div<=1;
        divisor<=8'h02;
    end
    @(posedge clk) begin
        #3;
        En<=1;
        ld_div<=0;
        divisor<=8'hff;
    end
    #1000;
    En<=0;
    rst<=1;
    #50;
    rst<=0;
    #50;  
    @(negedge clk ) begin
        ld_div<=1;
        divisor<=8'h00;
    end
    @(posedge clk) begin
        #3;
        En<=1;
        ld_div<=0;
        divisor<=8'hff;
    end    
       


end
clock_Gen clock_gen_inst (
    .clk(clk) ,
    .divisor(divisor) ,
    .ld_divisor(ld_div)  ,
    .rst(rst) ,
    .En(En),
    .out_clk(out_clk) 
);




endmodule