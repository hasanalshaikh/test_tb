class monitor;
    virtual add_if aif;
    mailbox #(constr_trx) mbx;
    constr_trx data;
    
    function new( mailbox #(constr_trx) mbx);
        //this.aif = aif;
        this.mbx = mbx;
    endfunction
    
    task run();
        data = new();
        forever begin
            @(posedge aif.clk);           
            data.dout <= aif.dout;
            data.empty <= aif.empty;
            data.full <= aif.full;
            //only for illustration purposes since
            $display("[MON]:\t dout:\t%2h \t empty:\t%0b \t full:\t%0b received at time %0t", aif.dout, aif.empty, aif.full, $time);
            //Why isn't data transaction getting "connected" with the interface?
            $display("[MON]:\t dout:\t%2h \t empty:\t%0b \t full:\t%0b received at time %0t from trx", data.dout, data.empty, data.full, $time);

            mbx.put(data);
        end
    endtask
endclass
