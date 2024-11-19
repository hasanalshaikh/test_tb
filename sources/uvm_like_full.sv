`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
`include "generator_new.svh"
`include "driver_new.svh"
`include "monitor.svh"
`include "scoreboard.svh"
//`include "environment.svh"


interface add_if;
    logic clk;
    logic rst;
    logic wr;
    logic rd;
    logic [7:0] din;
    logic [7:0] dout;
    logic empty;
    logic full;
endinterface

class environment;
    //components
    generator gen;
    driver dr;
    monitor mon;
    scoreboard sco;
    int num_tests;
    //Events
    event next;//event for communicating between generator and scorebaord
    
    mailbox #(constr_trx) mbxgendr;//mailbox for generator and driver
    mailbox #(constr_trx) mbxgensco;//mailbox for generator and scorebaord
    mailbox #(constr_trx) mbxmonsco;//mailbox for monitor and scoreboard
    
    virtual add_if aif;
    
    function new(virtual add_if aif, input int count);
        this.num_tests=count;
        mbxgendr=new();
        mbxgensco=new();
        mbxmonsco=new();

        //connect mailboxes
        gen=new(mbxgendr,mbxgensco,count);
        dr=new(mbxgendr);
        mon=new(mbxmonsco);
        sco=new(mbxmonsco,mbxgensco);
        
        //connect interfaces
        this.aif=aif;
        dr.aif=this.aif;
        mon.aif=this.aif;
        
        //connect events
        gen.sconext=next;
        sco.scnext=next;                
    endfunction 
    
    task pre_test();
        dr.reset(); //Perform reset
    endtask
    
    task test();
        fork
            gen.run();
            dr.run();
            mon.run();
            sco.run();
        join_any //Join_all is problematic here since there are some forever loops in the TB components. Those tasks will likely never finish 
    endtask
    
    task post_test();
        wait(gen.done.triggered);
        $finish();
    endtask
    
    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass
module uvm_like_tb;
  	add_if aif(); //interface
  	
  	//DUT instantiation and connection
  	FIFO dut (.clk(aif.clk),.rst(aif.rst),.wr(aif.wr), .rd(aif.rd), .din(aif.din),.dout(aif.dout),.empty(aif.empty),.full(aif.full));
    
  	int num_of_stimulus=10;
    
    initial begin
        aif.clk<=0;

    end
    always #10 aif.clk <= ~aif.clk;

    environment env;    
    initial begin
        env=new(aif,num_of_stimulus);
        env.run();
    end
    
    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;  
    end
endmodule
