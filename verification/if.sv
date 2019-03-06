interface counter_if(input bit clock);
    bit        reset;
    bit        mode;
    bit        load;
    bit [31:0] data;     
    reg [31:0] data_out;  
    
    clocking drv_cb @(posedge clock);
        default input #1 output #1;
        output reset;
        output mode;
        output load;
        output data;
    endclocking
    
    clocking wr_mon_cb @(posedge clock);
        default input #1 output #1;
        input reset;
        input mode;
        input load;
        input data;
    endclocking
    
    clocking rd_mon_cb @(posedge clock);
        default input #1 output #1;
        input data_out;
    endclocking
    
    modport DRV_MP (clocking drv_cb);
    modport WR_MON_MP (clocking wr_mon_cb);
    modport RD_MON_MP (clocking rd_mon_cb);
    
endinterface : counter_if
