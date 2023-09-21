interface ahb3lite_bus_inf(
    input logic HCLK, 
    input logic HRESETn
  );    
    logic                   HSEL;
    logic [HADDR_SIZE -1:0] HADDR;
    logic [HDATA_SIZE -1:0] HWDATA;
    logic [HDATA_SIZE -1:0] HRDATA;
    logic                   HWRITE;
    logic [            2:0] HSIZE;
    logic [            2:0] HBURST;
    logic [            3:0] HPROT;
    logic [            1:0] HTRANS;
    //logic                   HMASTLOCK;
    logic                   HREADY;
    logic                   HREADYOUT;
    logic                   HRESP;
  
  //driver clocking block
  clocking driver_cb @(posedge HCLK);
    default input #1 output #1;
    output HSEL;
    output HADDR;
    output HWDATA;
    output HWRITE;
    output HSIZE;
    output HBURST;
    output HPROT;
    output HTRANS;
    //output HMASTLOCK;
    output HREADY;
    input HREADYOUT;
    input HRESP; 
    input HRDATA;
  endclocking

  //monitor clocking block
  clocking monitor_cb @(posedge HCLK);
    default input #1 output #1;
    input HSEL;
    input HADDR;
    input HWDATA;
    input HWRITE;
    input HSIZE;
    input HBURST;
    input HPROT;
    input HTRANS;
    //input HMASTLOCK;
    input HREADY;
    input HREADYOUT;
    input HRESP; 
    input HRDATA;
  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input HCLK, input HRESETn);
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input HCLK, input HRESETn);


  //   // Master CB Interface Definitions
  //   clocking cb_master @(posedge HCLK);
  //       output HSEL;
  //       output HADDR;
  //       output HWDATA;
  //       input  HRDATA;
  //       output HWRITE;
  //       output HSIZE;
  //       output HBURST;
  //       output HPROT;
  //       output HTRANS;
  //       output HMASTLOCK;
  //       input  HREADY;
  //       input  HRESP;
  //   endclocking
  
  //   modport master_cb (
  //     clocking cb_master,
  //     input    HRESETn
  //   );
  
  //   // Slave Interface Definitions
  //   clocking cb_slave @(posedge HCLK);
  //       input  HSEL;
  //       input  HADDR;
  //       input  HWDATA;
  //       output HRDATA;
  //       input  HWRITE;
  //       input  HSIZE;
  //       input  HBURST;
  //       input  HPROT;
  //       input  HTRANS;
  //       input  HMASTLOCK;
  //       input  HREADY;
  //       output HREADYOUT;
  //       output HRESP;
  //   endclocking
  
  //   modport slave_cb (
  //       clocking cb_slave,
  //       input HRESETn
  //   );
  // `endif
  
  //   modport master (
  //       input  HRESETn,
  //       input  HCLK,
  //       output HSEL,
  //       output HADDR,
  //       output HWDATA,
  //       input  HRDATA,
  //       output HWRITE,
  //       output HSIZE,
  //       output HBURST,
  //       output HPROT,
  //       output HTRANS,
  //       output HMASTLOCK,
  //       input  HREADY,
  //       input  HRESP
  //   );
  
  //   modport slave (
  //       input  HRESETn,
  //       input  HCLK,
  //       input  HSEL,
  //       input  HADDR,
  //       input  HWDATA,
  //       output HRDATA,
  //       input  HWRITE,
  //       input  HSIZE,
  //       input  HBURST,
  //       input  HPROT,
  //       input  HTRANS,
  //       input  HMASTLOCK,
  //       input  HREADY,
  //       output HREADYOUT,
  //       output HRESP
  //   );
  endinterface
  