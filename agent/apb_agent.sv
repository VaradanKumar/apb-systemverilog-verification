`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent;
  apb_generator gen;
  apb_driver    drv;
  apb_monitor   mon;
  mailbox mbg2d;
  mailbox mbm2s;
  event gen_done;

  function new(virtual apb_interface vif);
    mbg2d = new();
    mbm2s = new();
    gen   = new(mbg2d, gen_done);
    drv   = new(mbg2d, vif);
    mon   = new(mbm2s, vif);
  endfunction

  task run();
    $display("[%0t] Inside the agent", $time);
    fork
      gen.run();
      drv.run();
      mon.run();
    join
  endtask
endclass

`endif
