class counter_transaction;
    rand bit        reset;
    rand bit        mode;     
    rand bit        load;
    rand bit [31:0] data;     
    
    reg [31:0]    data_out; 
    
    static int trans_id;
    static int no_of_up_trans;
    static int no_of_down_trans;
    
    constraint c_rst {
        reset dist {0 := 90, 1 := 10};}
    
    constraint c_load {
        load dist {0 := 70, 1 := 30};}
    
    constraint c_mode {
        mode dist {0 := 50, 1 := 50};}
    
    constraint c_data {
        data inside {[0:32'hFFFFFFFF]};}
    
    function new();
        trans_id++;
    endfunction
    
    virtual function void display(input string message);
        $display("----------------------------------------------");
        $display("%s", message);
        $display("\trst = %0d", reset);
        $display("\tload = %0d", load);
        $display("\tmode = %0d", mode);
        $display("\tdata = %0h", data);          
        $display("\tdata_out = %0h", data_out);  
        $display("\ttransaction no = %0d", trans_id);
        $display("\tup transaction no = %0d", no_of_up_trans);
        $display("\tdown transaction no = %0d", no_of_down_trans);
        $display("----------------------------------------------");
    endfunction
    
    function void post_randomize();
        if(this.mode == 0)
            no_of_down_trans++;
        else  // this.mode == 1
            no_of_up_trans++;
            
        this.display("Randomized transaction");
    endfunction
    
endclass : counter_transaction
