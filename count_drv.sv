class count_drv;

	virtual count_if.DRV_MP drv_if;

	count_trans data2duv;

	mailbox #(count_trans)gen2drv;

	function new(mailbox #(count_trans)gen2drv,
		     virtual count_if.DRV_MP drv_if);
		this.gen2drv = gen2drv;
		this.drv_if = drv_if;
	endfunction

	virtual task drive();
		@(drv_if.drv_cb);
#5;
		drv_if.drv_cb.rst<=data2duv.rst;
		drv_if.drv_cb.load<=data2duv.load;
		drv_if.drv_cb.mode<=data2duv.mode;
		drv_if.drv_cb.data<=data2duv.data;
		data2duv.display("transaction driven");
	endtask

	virtual task start();
		@(drv_if.drv_cb);
		drv_if.drv_cb.rst<=0;
		drv_if.drv_cb.load<=0;
		drv_if.drv_cb.mode<=0;
		drv_if.drv_cb.data<=0;

		fork forever
			begin
			     gen2drv.get(data2duv);
			     drive();
			end
		join_none
		$display("driver:started driving at time %t",$time);
	endtask
 endclass
