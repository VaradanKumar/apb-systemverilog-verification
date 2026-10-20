`ifndef APB_ENV_SV
`define APB_ENV_SV

class apb_env;
  apb_agent      agent;
  apb_scoreboard sb;

  function new(virtual apb_interface vif);
    agent = new(vif);
    sb    = new(agent.mbm2s);
  endfunction

  task run();
    $display("[%0t] Inside the environment", $time);
    fork
      agent.run();
      sb.run();
    join
  endtask
endclass

`endif
