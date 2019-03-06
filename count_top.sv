module count_top();

//	import count_pkg::*;
	parameter cycle = 10;
	reg clk;
	count_if DUV_IF(clk);
	count_test test_h;
	
	counter_32 DUT(.clk(clk),
			.rst(DUV_IF.rst),
			.load(DUV_IF.load),
			.mode(DUV_IF.mode),
			.data(DUV_IF.data),
			.data_out(DUV_IF.data_out));

	initial begin
		clk=1'b0;
		forever #(cycle/2) clk = ~clk;
	end

	initial begin
		if($test$plusargs("TEST1"))
		begin
			test_h = new(DUV_IF,DUV_IF,DUV_IF);
//			int no_of_transactions=100;
			test_h.build();
			test_h.run();
			$finish;
		end
	end

	initial begin
		$shm_open("wave.shm");
		$shm_probe("ACTMF");
	end
endmodule
