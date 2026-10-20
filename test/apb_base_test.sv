`ifndef APB_BASE_TEST_SV
`define APB_BASE_TEST_SV

class apb_base_test;
  apb_env env;

  function new(virtual apb_interface vif);
    env = new(vif);
  endfunction

  task run();
    $display("[%0t] Base test has started", $time);
    fork
      env.run();
      begin
        @(env.sb.sb_done);
        $display("[%0t] Scoreboard has completed all transactions", $time);
      end
    join_any

    disable fork;
    $display("[%0t] Transactions processed = %0d", $time, env.sb.count);
    $display("[%0t] Pass count = %0d", $time, env.sb.pass_count);
    $display("[%0t] Error count = %0d", $time, env.sb.error_count);
    $finish;
  endtask
endclass

`endif
