class scoreboard;
    constr_trx tr,trref;
    mailbox #(constr_trx) mbx;//mailbox for receiving data from monitor
    mailbox #(constr_trx) mbxgen; //mailbox 
    event scnext;
    bit signed [7:0] res;
    int score=0;
    
    function new(mailbox #(constr_trx) mbx, mailbox #(constr_trx) mbxgen);
        this.mbx = mbx;
        this.mbxgen=mbxgen;
    endfunction
    
    
    task run();
        forever begin
            mbxgen.get(trref);//get data from generator
            $display("[SCO]:\t wr:\t%0b \t rd:\t%0b \t din:\t%2h received from [GEN] at time %0t", trref.wr, trref.rd,trref.din, $time);
            //this.res=add_signed_numbers(trref.in0,trref.in1);
            //$display("Correct result should be:\t%0d", this.res);
            
            mbx.get(tr);//get data from monitor

            $display("[SCO]:\t dout:\t%2h \t empty:\t%0b \t full:\t%0b received from [MON] at time %0t", tr.dout, tr.empty, tr.full, $time);
            
            ->scnext;
        end       
    endtask

endclass