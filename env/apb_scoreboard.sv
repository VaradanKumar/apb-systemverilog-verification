`ifndef APB_SCOREBOARD_SV
`define APB_SCOREBOARD_SV

class apb_scoreboard;
  mailbox mbm2s;
  apb_transaction pkt;
  int error_count = 0;
  int pass_count  = 0;
  int count       = 0;
  event sb_done;
  logic [31:0] mem [0:255];

  function new(mailbox mbm2s);
    this.mbm2s = mbm2s;
  endfunction

  task run();
    $display("[%0t] Scoreboard started", $time);
    forever begin
      mbm2s.get(pkt);
      count++;

      if (pkt.pslverr == 1'b1) begin
        $display("[%0t] SCOREBOARD: APB transaction error", $time);
        error_count++;
      end
      else if (pkt.pwrite == 1'b1) begin
        // Model the write in the reference memory.
        if (pkt.paddr < 256)
          mem[pkt.paddr] = pkt.pwdata;
        else begin
          $display("[%0t] SCOREBOARD: write address out of range: %0d", $time, pkt.paddr);
          error_count++;
        end
      end
      else begin
        // A pass is counted for each successful read-data comparison.
        if ((pkt.paddr < 256) && (mem[pkt.paddr] === pkt.prdata)) begin
          $display("[%0t] SCOREBOARD: READ PASS addr=%0d data=%0d", $time, pkt.paddr, pkt.prdata);
          pass_count++;
        end
        else begin
          $display("[%0t] SCOREBOARD: READ FAIL addr=%0d expected=%0d actual=%0d",
                   $time, pkt.paddr,
                   (pkt.paddr < 256) ? mem[pkt.paddr] : 32'hxxxx_xxxx,
                   pkt.prdata);
          error_count++;
        end
      end

      if (count == 4)
        -> sb_done;
    end
  endtask
endclass

`endif
