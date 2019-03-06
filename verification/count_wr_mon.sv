class counter_write_monitor;
    virtual counter_if.WR_MON_MP wr_mon_if;
    
    counter_transaction data2rm;
    counter_transaction wr_data;
    
    mailbox #(counter_transaction) wrmon2rm;
    
    function new(virtual counter_if.WR_MON_MP wr_mon_if,
                 mailbox #(counter_transaction) wrmon2rm);
        this.wr_mon_if = wr_mon_if;
        this.wrmon2rm = wrmon2rm;
        this.wr_data = new();
    endfunction
    
    virtual task monitor();
        @(wr_mon_if.wr_mon_cb)
        begin
            wr_data.reset = wr_mon_if.wr_mon_cb.reset;
            wr_data.mode  = wr_mon_if.wr_mon_cb.mode;
            wr_data.load  = wr_mon_if.wr_mon_cb.load;
            wr_data.data  = wr_mon_if.wr_mon_cb.data;
            
            $display("Write Monitor: Captured transaction at time %0t", $time);
            wr_data.display("Data from write monitor");
        end
    endtask
    
    virtual task start();
        fork
            forever begin
                monitor();
                data2rm = new wr_data;
//                data2rm.reset = wr_data.reset;
//                data2rm.mode  = wr_data.mode;
//                data2rm.load  = wr_data.load;
//                data2rm.data  = wr_data.data;
                wrmon2rm.put(data2rm);
            end
        join_none
        
        $display("Write Monitor: Started at time %0t", $time);
    endtask
    
endclass : counter_write_monitor
