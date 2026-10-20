`timescale 1ns/1ps

import apb_agent_pkg::*;
import apb_env_pkg::*;
import apb_test_pkg::*;

module apb_top;
  bit pclk;
  apb_interface vif();
  apb_base_test test;

  initial begin
    pclk = 1'b0;
    forever #5 pclk = ~pclk;
  end

  assign vif.pclk = pclk;

  initial begin
    vif.rst_n = 1'b0;
    repeat (2) @(posedge pclk);
    vif.rst_n = 1'b1;
  end

  apb_slave dut(vif);

  initial begin
    $display("[%0t] APB TOP STARTED", $time);
    test = new(vif);
    $display("[%0t] TEST CREATED", $time);
    test.run();
    $display("[%0t] TEST RUN RETURNED", $time);
  end

  // Failsafe watchdog in case the testbench stops making progress.
  initial begin
    #10000;
    $display("[%0t] Watchdog timeout: simulation did not finish normally", $time);
    $finish;
  end
endmodule
