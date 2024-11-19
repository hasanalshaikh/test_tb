class driver;
    virtual add_if aif;
    mailbox #(constr_trx) mbx;
    constr_trx tr;
    
    function new (mailbox #(constr_trx) mbx);
        this.mbx = mbx;
    endfunction 

    task reset();
        aif.rst <= 1'b1; //Non-blocking assignment
        repeat(5) @(posedge aif.clk);
        @(negedge aif.clk);
        aif.rst <= 1'b0; // Deassert reset synchronously
        $display("[DRV]: RESET DONE at time %0t", $time);
    endtask

    task run();
        forever begin
            mbx.get(tr);
            $display("[DRV]:\t wr:\t%0b \t rd:\t%0b \t din:\t%2h received at time %0t", tr.wr, tr.rd, tr.din, $time);
              @(posedge aif.clk);
              aif.wr<=tr.wr;
              aif.rd<=tr.rd;
              aif.din<=tr.din;
        end
    endtask 
endclass
