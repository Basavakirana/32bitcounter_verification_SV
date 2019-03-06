count_rm();

	count_trans wr_mon_data;

	count_trans ref_count;

	mailbox #(count_trans)wrmon2rm;
	mailbox #(count_trans)rm2sb;

	function new(mailbox #(count_trans)wrmon2rm,
		     mailbox #(count_trans)rm2sb);
		this.wrmon2rm = wrmon2rm;
		this.rm2sb = rm2sb;
	endfunction

	virtual task count_mod(count_trans wr_mon_data);
	begin
	     if(wr_mon_data.rst || wr_mon_data.load & wr_mon_data.data >= 32'hFFFFFFFF-1)
		ref_count.data_out=32'b0;
	     else if(wr_mon_data.load)
		ref_count.data_out = wr_mon_data.data_in;
	     else
		if(wr_mon_data.mode)
		   begin
			if(wr_mon_data.data_out>=32'hFFFFFFFF-1)
				ref_count.data_out=32'b0;
		   	else
				ref_count.data_out=ref_count_data_out+1;
		   end
		else
		    begin
			 if(wr_mon_data.data_out<=32'b0)
				ref_count.data_out=32'hFFFFFFFF-1;
			 else
				ref_count.data_out=ref_count.data_out-1;
		    end
	end
	endtask

	virtual task start();
	fork begin
		forever begin
			wrmon2rm.get(wr_mon_data);
			count_mod(wr_mon_data);
			rm2sb.put(wr_mon_data);
		end
	end
	endtask
endclass:
