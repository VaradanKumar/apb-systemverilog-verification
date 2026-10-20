`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor;
  apb_transaction pkt;
  mailbox mbm2s;
  virtual apb_interface vif;

  function new(mailbox mbm2s, virtual apb_interface vif);
    this.mbm2s = mbm2s;
    this.vif   = vif;
  endfunction

  task run();
    $display("[%0t] Monitor started", $time);
    forever begin
      @(vif.monitor_cb);
      if (vif.monitor_cb.psel && vif.monitor_cb.penable && vif.monitor_cb.pready) begin
        pkt = new();
        pkt.psel    = vif.monitor_cb.psel;
        pkt.penable = vif.monitor_cb.penable;
        pkt.paddr   = vif.monitor_cb.paddr;
        pkt.pwrite  = vif.monitor_cb.pwrite;
        pkt.pwdata  = vif.monitor_cb.pwdata;
        pkt.prdata  = vif.monitor_cb.prdata;
        pkt.pready  = vif.monitor_cb.pready;
        pkt.pslverr = vif.monitor_cb.pslverr;

        $display("[%0t] MONITOR: %s, addr=%0d, wdata=%0d, rdata=%0d, PSLVERR=%0b",
                 $time, pkt.pwrite ? "WRITE" : "READ", pkt.paddr,
                 pkt.pwdata, pkt.prdata, pkt.pslverr);
        mbm2s.put(pkt);
      end
    end
  endtask
endclass

`endif
