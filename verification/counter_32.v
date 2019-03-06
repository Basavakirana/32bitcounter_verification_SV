module counter_32_bit(
	input bit clk,
	input bit rst,
	input bit mode,
	input bit load,
	input bit[31:0]data,
	output reg[31:0]data_out);

	localparam reg[31:0] max_count=32'hFFFFFFFF;
	localparam reg[31:0]min_count=32'0;

	always @(posedge clk or posedge rst)
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
				data_out==max_count;
			else
				data_out<=data_out-1;
		end
	end
endmodule
