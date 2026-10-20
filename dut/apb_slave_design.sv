`timescale 1ns/1ps
`ifndef APB_SLAVE_DESIGN_SV
`define APB_SLAVE_DESIGN_SV

module apb_slave(apb_interface dif);
  logic [31:0] mem [0:255];
  integer i;

  // Write memory on a completed APB access; clear memory on active-low reset.
  always_ff @(posedge dif.pclk or negedge dif.rst_n) begin
    if (!dif.rst_n) begin
      for (i = 0; i < 256; i++)
        mem[i] <= 32'b0;
    end
    else begin
      if (dif.psel && dif.penable && dif.pwrite && dif.pready) begin
        if (dif.paddr < 256)
          mem[dif.paddr] <= dif.pwdata;
      end
    end
  end

  // Zero-wait-state response. Addresses outside 0..255 return PSLVERR.
  always_comb begin
    dif.pready  = 1'b0;
    dif.prdata  = 32'b0;
    dif.pslverr = 1'b0;

    if (dif.psel && dif.penable) begin
      dif.pready = 1'b1;
      if (dif.paddr >= 256) begin
        dif.pslverr = 1'b1;
      end
      else if (dif.pwrite == 1'b0) begin
        dif.prdata = mem[dif.paddr];
      end
    end
  end
endmodule

`endif
