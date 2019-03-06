class count_env;

	virtual count_if.DRV_MP drv_if;
	virtual count_if.WR_MON_MP wr_mon_if;
	virtual count_if.RD_MON_MP rd_mon_if;

	mailbox #(count_trans) gen2drv =new();
	mailbox #(count_trans) wrmon2rm =new();
	mailbox #(count_trans) rdmon2sb =new();
	mailbox #(count_trans) rm2sb =new();

	count_gen gen_h;
	count_drv drv_h;
	count_wr_mon wr_monh;
	count_rd_mon rd_monh;
	count_rm rm_h;
	count_sb sb_h;

	function new(virtual count_if.DRV_MP drv_if,
		     virtual count_if.WR_MON_MP wr_mon_if,
		     virtual count_if.RD_MON_MP rd_mon_if);
		this.drv_if = drv_if;
		this.wr_mon_if = wr_mon_if;
		this.rd_mon_if = rd_mon_if;
	endfunction

	virtual task build;
		gen_h = new(gen2drv);
		drv_h = new(gen2drv,drv_if);
		wr_monh = new(wr_mon_if,wrmon2rm);
		rd_monh = new(rd_mon_if,rdmon2sb);
		rm_h = new(wrmon2rm,rm2sb);
		sb_h = new(rdmon2sb,rm2sb);
	endtask

	virtual task run();
		reset_dut;
		start();
		stop();
		sb_h.report();
	endtask

	virtual task reset_dut();
		@(drv_if.drv_cb);
			drv_if.drv_cb.rst <= 1'b1;
		@(drv_if.drv_cb);	
			drv_if.drv_cb.rst <= 1'b0;
	endtask

	virtual task start();
		gen_h.start();
		drv_h.start();
		wr_monh.start();
		rd_monh.start();
		rm_h.start();
		sb_h.start();
	endtask

	virtual task stop();
		wait(sb_h.DONE.triggered);
	endtask
endclass
