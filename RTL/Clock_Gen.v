module clock_Gen (
    input  wire clk ,
    input  wire [7:0] divisor ,
    input  wire ld_divisor    ,
    input  wire rst ,
    input  wire En,
    output wire out_clk
   // output wire out_clk_bar
    
);


reg [7:0] count = 0;
reg [7:0] count_shadow ;

reg out ;

//assign out_clk_bar = count_shadow ? ~out:~clk ; 
assign out_clk = count_shadow ? out:clk; 


always @(rst or posedge clk ) begin
    
    if (rst) begin
        out<=0;
        count<=0;
        count_shadow<=0;
    end

    else begin
    
     if (ld_divisor) begin
        if (divisor%2 != 0 ) begin
        count_shadow<=0;    
        end
        else begin
        count_shadow<=divisor;    
        end
        count<=0;
    end
    else begin 
        if (En) begin
                if (count == count_shadow/2 - 1 ) begin
                    out <= ~out;
                    count<=0 ;
                end
            count=count+1;  
            end         
        else begin
            count<=0;
        end
            
        end
   
        end
end




    
endmodule