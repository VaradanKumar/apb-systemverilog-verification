`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver;
  apb_transaction pkt;
  mailbox mbg2d;
  virtual apb_interface vif;
  int wait_cycles;

  function new(mailbox mbg2d, virtual apb_interface vif);
    this.mbg2d = mbg2d;
    this.vif   = vif;
  endfunction

  task run();
    $display("[%0t] Driver started", $time);

    // Drive the bus to the idle state before waiting for reset release.
    vif.master_cb.psel    <= 1'b0;
    vif.master_cb.penable <= 1'b0;
    vif.master_cb.paddr   <= '0;
    vif.master_cb.pwrite  <= 1'b0;
    vif.master_cb.pwdata  <= '0;
    wait (vif.rst_n === 1'b1);
    @(vif.master_cb);

    forever begin
      mbg2d.get(pkt);

      // Process the current item and any additional items already queued.
      do begin
        // APB setup phase.
        vif.master_cb.psel    <= 1'b1;
        vif.master_cb.penable <= 1'b0;
        vif.master_cb.paddr   <= pkt.paddr;
        vif.master_cb.pwrite  <= pkt.pwrite;
        vif.master_cb.pwdata  <= pkt.pwdata;
        @(vif.master_cb);

        // APB access phase.
        vif.master_cb.psel    <= 1'b1;
        vif.master_cb.penable <= 1'b1;
        vif.master_cb.paddr   <= pkt.paddr;
        vif.master_cb.pwrite  <= pkt.pwrite;
        vif.master_cb.pwdata  <= pkt.pwdata;
        @(vif.master_cb);

        wait_cycles = 0;
        while (vif.master_cb.pready !== 1'b1) begin
          @(vif.master_cb);
          wait_cycles++;
          if (wait_cycles >= 10) begin
            $fatal(1, "APB driver timed out: PREADY did not become 1 within 10 cycles");
          end
        end

        pkt.pready  = vif.master_cb.pready;
        pkt.pslverr = vif.master_cb.pslverr;

        if (pkt.pslverr === 1'b1)
          $error("APB slave reported PSLVERR for address %0d", pkt.paddr);

        if (pkt.pwrite === 1'b0)
          pkt.prdata = vif.master_cb.prdata;
        else
          pkt.prdata = 32'b0;

      end while (mbg2d.try_get(pkt));

      // Return to idle between batches of transactions.
      vif.master_cb.psel    <= 1'b0;
      vif.master_cb.penable <= 1'b0;
      vif.master_cb.paddr   <= '0;
      vif.master_cb.pwrite  <= 1'b0;
      vif.master_cb.pwdata  <= '0;
      @(vif.master_cb);
    end
  endtask
endclass

`endif
