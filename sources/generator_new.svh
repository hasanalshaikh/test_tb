`include "transaction_new.svh"
class generator;
    constr_trx tr;
    mailbox #(constr_trx) mbx; //Mailbox for sending trx data to driver 
    mailbox #(constr_trx) mbxsb; //Mailbox for send trx data from scoreboard
  	event done; //will trigger after generating all transactions.
  	event sconext; //will trigger when scoreboard is ready to calculate the next one.
  	int num;
  	//event drv_rcv;
  
  	function new(mailbox #(constr_trx) mbx, mailbox #(constr_trx) mbxsb, input int num);
        this.mbx=mbx;
        this.mbxsb=mbxsb;
    	this.num=num;
        tr=new();
    endfunction 
    
  	task run();
        //tr = new();
      	repeat (this.num) begin
            assert (tr.randomize()) else $error("[GEN]: RANDOMIZATION FAILED");
            tr.display("GEN");
            tr.flag=tr.flag+1;//increment the flag so that we know how many stimuli have been generated.
            this.mbx.put(tr.copy);
            this.mbxsb.put(tr.copy);
         	@(this.sconext);
        end
      ->this.done;
    endtask
endclass
