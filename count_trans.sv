class count_trans;
	bit clk;
	bit rst;
	bit mode;
	bit load;
	bit[31:0]data;
	logic[31:0]data_out;

	static int trans_id;
	static int no_of_up_trans;
	static int no_of_down_trans;

	constraint c_rst{rst dist{0:=70,1:=30};}
	constraint c_load{load dist{0:=70,1:=30};}
	constraint c_mode{mode dist{0:=50,1:=50};}
	constraint c_data{data inside{[5:32'hFFFFFFFF]};}

	virtual function void display(input string message);
	$display("----------------------------------------------------------");
	$display("%s",message);
	$display("\trst=%b",rst);
	$display("\tload=%b",load);
	$display("\tmode=%b",mode);
	$display("\tdata=%h",data);
	$display("\tdata_out=%h",data_out);
	$display("\ttransaction no=%d",trans_id);
	$display("\tno of uptrans=%d",no_of_up_trans);
	$display("\tno of downtrasn=%d",no_of_down_trans);
	$display("-----------------------------------------------------------");
	endfunction 

	function new();
		trans_id++;
	endfunction

	function void post_randomize();
		if(mode==0)
			no_of_down_trans++;
		if(mode==1)
			no_of_up_trans++;
		this.display("randomized transactions");
	endfunction
endclass

