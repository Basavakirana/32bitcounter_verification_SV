class count_test;

	virtual count_if.DRV_MP drv_if;
	virtual count_if.WR_MON_MP wr_mon_if;
	virtual count_if.RD_MON_MP rd_mon_if;

	count_env env_h;

	function new(virtual count_if.DRV_MP drv_if,
		     virtual count_if.WR_MON_MP wr_mon_if,
		     virtual count_if.RD_MON_MP rd_mon_if);
		this.drv_if = drv_if;
		this.wr_mon_if = wr_mon_if;
		this.rd_mon_if = rd_mon_if;
		env_h = new(drv_if,wr_mon_if,rd_mon_if);
	endfunction

	virtual task build();
		env_h.build();
	endtask

	virtual task run();
		env_h.run();
	endtask
endclass
	
