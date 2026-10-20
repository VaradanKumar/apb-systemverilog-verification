`timescale 1ns/1ps

interface apb_interface;
  logic        pclk;
  logic        rst_n;
  logic [31:0] paddr;
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [31:0] pwdata;
  logic        pready;
  logic [31:0] prdata;
  logic        pslverr;

  // Master drives request signals and samples the slave response.
  clocking master_cb @(posedge pclk);
    output paddr, psel, penable, pwrite, pwdata;
    input  prdata, pready, pslverr;
  endclocking

  // Slave samples the request and drives its response.
  clocking slave_cb @(posedge pclk);
    input  paddr, psel, penable, pwrite, pwdata;
    output prdata, pready, pslverr;
  endclocking

  // Passive monitor view of the bus.
  clocking monitor_cb @(posedge pclk);
    input paddr, psel, penable, pwrite, pwdata;
    input prdata, pready, pslverr;
  endclocking

  modport master (clocking master_cb);
  modport slave  (clocking slave_cb);

endinterface
