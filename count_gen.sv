class count_gen;
	count_trans trans_h;
	count_trans data2send;
	
	int no_of_transactions;

	mailbox #(count_trans)gen2drv;

	function new(mailbox #(count_trans)gen2drv,int num_trans=100);
		this.gen2drv=gen2drv;
		this.trans_h = new();
		this.no_of_transactions=num_trans;
	endfunction

	virtual task start();
	fork
		begin
		for(int i=0;i<no_of_transactions;i++)
		begin
			if(!trans_h.randomize)
			begin
				$error("randomized transactions failed %d",i);
			end
			trans_h.trans_id++;
			data2send = new trans_h;
			gen2drv.put(data2send);
		end
		$display("generator:generating trans completed %d",no_of_transactions);
		end
	join_none
	endtask
endclass
