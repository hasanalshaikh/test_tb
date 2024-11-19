class transaction;
//    bit clk;
//    bit reset_n;
//  	rand bit reset_n;
    rand bit wr;
    rand bit rd;
    rand bit [7:0] din;
    bit [7:0] dout;
    bit empty;
    bit full;
    
    function transaction copy();
        copy=new();
      	//copy.reset_n=this.reset_n;
      	copy.wr=this.wr;
		copy.rd=this.rd;
      	copy.din=this.din;
      	copy.dout=this.dout;
      	copy.empty=this.empty;
      	copy.full=this.full;
    endfunction 
    
    function void display(input string name);
      $display("[%0s]:\t wr:\t%0b \t rd:\t%0b \t din:\t%2h generated at time %0t",name, this.wr, this.rd, this.din, $time);
    endfunction
endclass

class constr_trx extends transaction;
  int flag=0;//flag to keep track of how many reads/writes I have generated. 
  
  function constr_trx copy();
        copy=new();
      	//copy.reset_n=this.reset_n;
      	copy.wr=this.wr;
		copy.rd=this.rd;
      	copy.din=this.din;
      	copy.dout=this.dout;
      	copy.empty=this.empty;
      	copy.full=this.full;
endfunction 

  constraint rd_wr_constr {this.rd==0 -> this.wr==1; this.rd==1 -> this.wr==0;}
  constraint full_check { //until we have generated a set amount of writes, we won't generate rd=1. This is to check the full/empty logic
                            if(flag inside {[0:2]}) {
                                this.rd==0;
                            }  
                            else{
                                this.rd==1;
                            }
                        }
endclass