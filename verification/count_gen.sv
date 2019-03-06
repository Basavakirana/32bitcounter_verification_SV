class counter_generator;
    counter_transaction trans_h;
    counter_transaction data2send;
    
    int number_of_transactions;
    
    mailbox #(counter_transaction) gen2drv;
    
    function new(mailbox #(counter_transaction) gen2drv, int num_trans = 100);
        this.gen2drv = gen2drv;
        this.trans_h = new();
        this.number_of_transactions = num_trans;
    endfunction
    
    virtual task start();
        fork
            begin
                for(int i=0; i<number_of_transactions; i++) begin
                    if(!trans_h.randomize()) begin
                        $error("Randomization failed at transaction %0d", i);
                    end
                    data2send = new trans_h;
//                    data2send.reset = trans_h.reset;
//                    data2send.mode = trans_h.mode;
//                    data2send.load = trans_h.load;
//                    data2send.data = trans_h.data;
                    gen2drv.put(data2send);
                    // #10;
                end
                $display("Generator: Completed generating %0d transactions", number_of_transactions);
            end
        join_none
    endtask
    
endclass : counter_generator
