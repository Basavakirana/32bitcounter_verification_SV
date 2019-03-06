module counter_32(
	input logic clk,
	input logic rst,
	input logic mode,
	input logic load,
	input logic[31:0]data,
	output logic[31:0]data_out);

	localparam logic[31:0] max_count=32'hFFFF_FFFF;
	localparam logic[31:0]min_count=0;

	always@(posedge clk or posedge rst)
	begin
		if(rst)
			data_out<=min_count;
		else if(load)
			data_out<=data;
		else if(mode)
		begin
			if(data_out==max_count)	
				data_out<=min_count;
			else
				data_out<=data_out+1;
		end
		else
		begin
			if(data_out==min_count)
				data_out<=max_count;
			else
				data_out<=data_out-1;
		end
	end
endmodule
