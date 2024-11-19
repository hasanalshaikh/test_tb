class environment;
    //components
    generator gen;
    driver dr;
    monitor mon;
    scoreboard sco;
    //Events
    event next;//event for communicating between generator and scorebaord
    
    mailbox #(transaction) mbxgendr;//mailbox for generator and driver
    mailbox #(transaction) mbxgensco;//mailbox for generator and scorebaord
    mailbox #(transaction) mbxmonsco;//mailbox for monitor and scoreboard
    
    virtual add_if aif;
    
    function new(virtual add_if aif);
        mbxgendr=new();
        mbxgensco=new();
        mbxmonsco=new();
        
        gen=new();
    endfunction 
endclass