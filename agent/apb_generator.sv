`ifndef APB_GENERATOR_SV
`define APB_GENERATOR_SV

class apb_generator;
  apb_transaction pkt;
  mailbox mbg2d;
  event gen_done;

  function new(mailbox mbg2d, event gen_done);
    this.mbg2d   = mbg2d;
    this.gen_done = gen_done;
  endfunction

  task run();
    $display("[%0t] Generator started", $time);

    // Directed write/read pair at address 10.
    pkt = new();
    pkt.pwrite = 1'b1;
    pkt.paddr  = 32'd10;
    pkt.pwdata = 32'd100;
    mbg2d.put(pkt);

    pkt = new();
    pkt.pwrite = 1'b0;
    pkt.paddr  = 32'd10;
    pkt.pwdata = 32'd0;
    mbg2d.put(pkt);

    // Directed write/read pair at address 20.
    pkt = new();
    pkt.pwrite = 1'b1;
    pkt.paddr  = 32'd20;
    pkt.pwdata = 32'd200;
    mbg2d.put(pkt);

    pkt = new();
    pkt.pwrite = 1'b0;
    pkt.paddr  = 32'd20;
    pkt.pwdata = 32'd0;
    mbg2d.put(pkt);

    -> gen_done;
    $display("[%0t] Generator queued 4 transactions", $time);
  endtask
endclass

`endif
