interface count_if(input bit clk);
	logic rst;
	logic mode;
	logic load;
	logic[31:0]data;
	logic[31:0]data_out;

	clocking drv_cb @(posedge clk);
	default input #1 output #1;
		output rst;
		output load;
		output mode;
		output data;
	endclocking

	clocking wr_mon_cb @(posedge clk);
	default input #1 output #1;
		input rst;
		input load;
		input mode;
		input data;
	endclocking

	clocking rd_mon_cb @(posedge clk);
	default input #1 output #1;
		input data_out;
	endclocking

	modport DRV_MP (clocking drv_cb);
	modport WR_MON_MP (clocking wr_mon_cb);
	modport RD_MON_MP (clocking rd_mon_cb);

endinterface
