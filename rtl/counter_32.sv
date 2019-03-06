module updown_counter_32bit (
    input  logic        clk,
    input  logic        rst,      
    input  logic        mode,      
    input  logic        load,
    input  logic [31:0] data,
    output logic [31:0] data_out
);

    localparam logic [31:0] MAX_COUNT = 32'hFFFFFFFF;
    localparam logic [31:0] MIN_COUNT = 32'd0;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= MIN_COUNT;
        else if (load)
            data_out <= data;
        else if (mode) begin
            if (data_out == MAX_COUNT)
                data_out <= MIN_COUNT;
            else
                data_out <= data_out + 1'b1;
        end
        else begin
            if (data_out == MIN_COUNT)
                data_out <= MAX_COUNT;
            else
                data_out <= data_out - 1'b1;
        end
    end

endmodule 
