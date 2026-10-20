`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

class apb_transaction;
  bit        psel;
  bit        penable;
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  bit [31:0] prdata;
  rand bit        pwrite;
  bit             pslverr;
  bit             pready;

  constraint c1 { paddr  inside {[0:255]}; }
  constraint c2 { pwdata inside {[0:255]}; }
  constraint c3 { pwrite inside {0, 1}; }

  function void display();
    $display("[%0t] paddr=%0d | pwdata=%0d | prdata=%0d | pwrite=%0d | penable=%0d | psel=%0d | pready=%0d | pslverr=%0d",
             $time, paddr, pwdata, prdata, pwrite, penable, psel, pready, pslverr);
  endfunction
endclass

`endif
