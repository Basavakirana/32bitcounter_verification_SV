class count_sb;

    event DONE;

  count_trans rm_data;
  count_trans rd_mon_data;
  count_trans cov_data;
  
  mailbox #(count_trans) rm2sb;
  mailbox #(count_trans) rdmon2sb;
  
  int data_verified=0;
  int ref_data=0;
  int mon_data=0;
  int no_of_mismatches=0;
  int no_of_matches=0;
  int no_of_transactions=100;

 covergroup mem_covg;
	option.per_instance=1;

	RST:coverpoint cov_data.rst;
	LOAD:coverpoint cov_data.load;
	MODE:coverpoint cov_data.mode;
	DATA:coverpoint cov_data.data{
    		bins bin0  = {[32'h00000000 : 32'h11111110]};
    		bins bin1  = {[32'h11111111 : 32'h22222221]};
    		bins bin2  = {[32'h22222222 : 32'h33333332]};
    		bins bin3  = {[32'h33333333 : 32'h44444443]};
    		bins bin4  = {[32'h44444444 : 32'h55555554]};
    		bins bin5  = {[32'h55555555 : 32'h66666665]};
    		bins bin6  = {[32'h66666666 : 32'h77777776]};
    		bins bin7  = {[32'h77777777 : 32'h88888887]};
    		bins bin8  = {[32'h88888888 : 32'h99999998]};
    		bins bin9  = {[32'h99999999 : 32'hAAAAAAA9]};
    		bins bin10 = {[32'hAAAAAAAA : 32'hBBBBBBBA]};
    		bins bin11 = {[32'hBBBBBBBB : 32'hCCCCCCCB]};
    		bins bin12 = {[32'hCCCCCCCC : 32'hDDDDDDDC]};
    		bins bin13 = {[32'hDDDDDDDD : 32'hEEEEEEED]};
    		bins bin14 = {[32'hEEEEEEEE : 32'hFFFFFFFF]};}
	DATAOUT:coverpoint cov_data.data_out{
	    	bins bin0  = {[32'h00000000 : 32'h11111110]};
    		bins bin1  = {[32'h11111111 : 32'h22222221]};
    		bins bin2  = {[32'h22222222 : 32'h33333332]};
    		bins bin3  = {[32'h33333333 : 32'h44444443]};
    		bins bin4  = {[32'h44444444 : 32'h55555554]};
    		bins bin5  = {[32'h55555555 : 32'h66666665]};
    		bins bin6  = {[32'h66666666 : 32'h77777776]};
    		bins bin7  = {[32'h77777777 : 32'h88888887]};
    		bins bin8  = {[32'h88888888 : 32'h99999998]};
    		bins bin9  = {[32'h99999999 : 32'hAAAAAAA9]};
    		bins bin10 = {[32'hAAAAAAAA : 32'hBBBBBBBA]};
    		bins bin11 = {[32'hBBBBBBBB : 32'hCCCCCCCB]};
    		bins bin12 = {[32'hCCCCCCCC : 32'hDDDDDDDC]};
    		bins bin13 = {[32'hDDDDDDDD : 32'hEEEEEEED]};
    		bins bin14 = {[32'hEEEEEEEE : 32'hFFFFFFFF]};}
	LxM: cross cov_data.load,cov_data.mode;
 endgroup

  function new(mailbox #(count_trans) rm2sb,
               mailbox #(count_trans) rdmon2sb,
               int num_trans = 100);
    this.rm2sb = rm2sb;
    this.rdmon2sb = rdmon2sb;
    this.no_of_transactions = num_trans;
    mem_covg = new();
  endfunction

  virtual task check(count_trans mon_data);
          if(rm_data.data_out == rd_mon_data.data_out) begin
            no_of_matches++;
            $display("----------------------------------------------------------");
            $display("MATCH #%0d", no_of_matches);
            $display("----------------------------------------------------------");
            $display("Reference Model Output: %h", rm_data.data_out);
            $display("DUT Output: %h", rd_mon_data.data_out);
            $display("----------------------------------------------------------");
          end
          else begin
            no_of_mismatches++;
            $display("----------------------------------------------------------");
            $display("MISMATCH #%0d", no_of_mismatches);
            $display("----------------------------------------------------------");
            $display("Reference Model Output: %h", rm_data.data_out);
            $display("DUT Output: %h", rd_mon_data.data_out);
	    rm_data.display("reference model data");
	    rd_mon_data.display("read monitor data");
            $display("----------------------------------------------------------");
          end
        cov_data = new rm_data;
	if(cov_data.data_out == rm_data.data_out)
	begin
		mem_covg.sample();
		data_verified++;
		if(data_verified >= no_of_transactions)
		begin
			->DONE;
            $display("DONE event triggered - %0d transactions verified", data_verified);
        end
	end
  endtask	

  virtual task start();
    fork
      begin
        forever begin
          rm2sb.get(rm_data);
	  ref_data++;
          rdmon2sb.get(rd_mon_data);
	  mon_data++;
          check(rd_mon_data);
	end
    end
    join_none
    $display("Scoreboard: Started at time %t", $time);
  endtask

  virtual function void report();
    $display("----------------------------------------------------------");
    $display("SCOREBOARD REPORT");
    $display("----------------------------------------------------------");
    $display("Total transactions from ref model: %d",ref_data);
    $display("Total transactions recieved from DUT: %d",mon_data);
    $display("Total transactions verified; %d",data_verified);
    $display("Number of matches: %0d", no_of_matches);
    $display("Number of mismatches: %0d", no_of_mismatches);
    $display("Total functional coverage: %.2f%%",mem_covg.get_inst_coverage());
    $display("----------------------------------------------------------");
  endfunction
endclass
