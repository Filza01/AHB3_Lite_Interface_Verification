parameter MEM_SIZE          = 64;       //Memory in Bytes
parameter MEM_DEPTH         = 256;     //Memory depth
parameter HADDR_SIZE        = 8;
parameter HDATA_SIZE        = 32;
parameter TECHNOLOGY        = "GENERIC";
parameter REGISTERED_OUTPUT = "NO";
parameter INIT_FILE         = "";

//including interfcae and testcase files
`include "interface.sv"
//----------------------------------------------------------
// `include "random_test.sv"
// `include "wr_rd_test.sv"
// `include "default_rd_test.sv"
// `include "wr_rd_same_addr_test.sv"  // test case for the verification of back-to-back "read" and "write" to the same address.
// `include "wr_rd_diff_addr_test.sv"  // test case for the verification of back-to-back "read" and "write" to the different address.
// `include "wr_rd_test.sv"       
// `include "wr_reset_rd.sv"      // test case to verify the "reset" by writing to few locations, assert the reset and then perform read operations
//----------------------------------------------------------


module tbench_top();
  //clock and reset signal declaration
  bit HCLK;
  bit HRESETn;

  //creatinng instance of interface, inorder to connect DUT and testcase
  ahb3lite_bus_inf intf(HCLK, HRESETn);
  
  //Testcase instance, interface handle is passed to test as an argument
  // test t1(intf);

  //clock generation
  always #5 HCLK = ~HCLK;

  //reset Generation
  initial begin
    HRESETn = 0;
    #50 HRESETn = 1;
  end
  
  //DUT instance, interface signals are connected to the DUT ports
  ahb3lite_sram1rw #(
    .MEM_SIZE      ( 64 ),
    .HADDR_SIZE    (32),
    .HDATA_SIZE    (16)
  ) s1 (
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
  

   initial begin
#3;
intf.HSEL=1;
@(posedge HCLK);
@(posedge HCLK);
intf.HSIZE = 2;
intf.HPROT = 1;
intf.HBURST = 0;
intf.HREADY = 1;
intf.HTRANS = 2;
intf.HWRITE=1;
intf.HADDR=29;
@(posedge HCLK);
#2;
intf.HWDATA=345;
@(posedge HCLK);
@(posedge HCLK);
#2
intf.HWRITE=0;
@(posedge HCLK);
@(posedge HCLK);
@(posedge HCLK);
$finish();
   end
 
endmodule