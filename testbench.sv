parameter MEM_SIZE          = 64;       //Memory in Bytes
parameter MEM_DEPTH         = 256;     //Memory depth
parameter HADDR_SIZE        = 16;
parameter HDATA_SIZE        = 32;
parameter TECHNOLOGY        = "GENERIC";
parameter REGISTERED_OUTPUT = "NO";
parameter INIT_FILE         = "";

//including interfcae and testcase files -------------------
`include "interface.sv"
//----------------------------------------------------------

// including test files ------------------------------------        
// `include "test_case1.sv"       // checks for random HWRITE on fixed HADDR = 4, where HREADY = 1, HBURST = 0, HSEL = 1, HTRANS = 2, HISIZE = 2
// `include "test_case2.sv"       // first at an an address and then read from it HREADY = 1;  HBURST = 0; HSEL = 1; HTRANS = 2; HSIZE = 2;
// `include "test_case3.sv"       // ready and wait states with HBURST = 0, HSEL = 1, HTRANS = 2, HISIZE = 2
// `include "test_case4.sv"       // IDLE and BUSY transfer state with HBURST = 0, HSEL = 1, HISIZE = 2, HREADY = 1
// `include "test_case5.sv"       // checks for HSEL = 0 with manual HADDR; HREADY = 1;  HBURST = 0; HTRANS = 2; HSIZE = 2 
// `include "test_case6.sv"       // HREADY = 0 permanentally, with manual HADDR, HBURST = 0, HSEL = 1, HTRANS = 2, HISIZE = 2
// `include "test_case7.sv"       // checks for different HSIZE values with manual HADDR, HREADY = 1, HBURST = 0, HSEL = 1, HTRANS = 2
`include "test_case8.sv" 
// `include "random_test.sv"
// make one for different HSIZE values
// make one for HRESETn
//----------------------------------------------------------


module tbench_top();
  //clock and reset signal declaration
  bit HCLK;
  bit HRESETn;

  //creatinng instance of interface, inorder to connect DUT and testcase
  ahb3lite_bus_inf intf(HCLK, HRESETn);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(intf);

   //clock generation
  always #5 HCLK = ~HCLK;

  //reset Generation
  initial begin
    HRESETn = 0;
    #3 HRESETn = 1;
  end
  
  //DUT instance, interface signals are connected to the DUT ports
  ahb3lite_sram1rw #(
    .MEM_SIZE      (MEM_SIZE),
    .HADDR_SIZE    (HADDR_SIZE),
    .HDATA_SIZE    (HDATA_SIZE)
  ) dut (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(intf.HSEL),
    .HADDR(intf.HADDR),
    .HWDATA(intf.HWDATA),
    .HWRITE(intf.HWRITE),
    .HSIZE(intf.HSIZE),
    .HBURST(intf.HBURST),
    .HPROT(intf.HPROT),
    .HTRANS(intf.HTRANS),
    .HREADY(intf.HREADY),
    .HREADYOUT(intf.HREADYOUT),
    .HRESP(intf.HRESP), 
    .HRDATA(intf.HRDATA)
   );
 
endmodule