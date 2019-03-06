class counter_driver;
    virtual counter_if.DRV_MP drv_if;
    
    counter_transaction data2duv;
    
    mailbox #(counter_transaction) gen2drv;
    
    function new(virtual counter_if.DRV_MP drv_if,
                 mailbox #(counter_transaction) gen2drv);
        this.drv_if = drv_if;
        this.gen2drv = gen2drv;
    endfunction
    
    virtual task drive();
        @(drv_if.drv_cb);
        drv_if.drv_cb.reset <= data2duv.reset;
        drv_if.drv_cb.mode  <= data2duv.mode;
        drv_if.drv_cb.load  <= data2duv.load;
        drv_if.drv_cb.data  <= data2duv.data;
        
        $display("Driver: Driving transaction at time %0t", $time);
        data2duv.display("Driven transaction");
    endtask
    
    virtual task start();
        drv_if.drv_cb.reset <= 0;
        drv_if.drv_cb.mode  <= 0;
        drv_if.drv_cb.load  <= 0;
        drv_if.drv_cb.data  <= 0;
        
        fork
            forever begin
                gen2drv.get(data2duv);
                drive();
            end
        join_none
        
        $display("Driver: Started at time %0t", $time);
    endtask
    
endclass : counter_driver
