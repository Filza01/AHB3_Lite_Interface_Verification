`include "defines.sv"

//including interfcae and testcase files -------------------
`include "interface.sv"
//----------------------------------------------------------

// including test files ------------------------------------        
// `include "test_case1.sv"       // NON SEQ, checks for random HWRITE on fixed HADDR = 4, where HREADY = 1, HBURST = 0, HSEL = 1, HTRANS = 2, HISIZE = 2
 //`include "test_case2.sv"       // NON SEQ, testing  write WORD case, first at an an address and then read from it HREADY = 1;  HBURST = 0; HSEL = 1; HTRANS = 2; HSIZE = 2; 
// `include "test_case3.sv"       // ready and wait states with HBURST = 0, HSEL = 1, HTRANS = 2, HISIZE = 2 
// `include "test_case4.sv"       // IDLE and BUSY transfer state with HBURST = 0, HSEL = 1, HISIZE = 2, HREADY = 0
// `include "test_case5.sv"       // checks for HSEL = 0 with manual HADDR; HREADY = 1;  HBURST = 0; HTRANS = 2; HSIZE = 2 
// `include "test_case6.sv"       // HREADY = 0 permanentally, with manual HADDR, HBURST = 0, HSEL = 1, HTRANS = 2, HISIZE = 2
// `include "test_case7.sv"       // checks for different HSIZE values with manual HADDR, HREADY = 1, HBURST = 0, HSEL = 1, HTRANS = 2
// `include "test_case8.sv"       // checks 4 beat wrapping burst, SEQ transfer
// `include "test_case9.sv"       // checks 4 beat incrementing burst, SEQ transfer
// `include "test_case10.sv"      // write WORD on manual addresses with HSIZE = 2 and read BYTE, HALFWORD and WORD from that addresses with HSIZE = 0,1  // check this test again
// `include "test_case11.sv"      // Waited transfer, IDLE to NONSEQ, checks for wait transfers on IDLE state, this test should fail, passed in display
// `include "test_case12.sv"      // testing write BYTE case
// `include "test_case13.sv"      // testing write HALFWORD case
// `include "test_case14.sv"      // Waited transfer, BUSY to SEQ for a fixed length burst, fail in some clk cycles when HREADY = 0, passed in display
// `include "test_case15.sv"      // Address changes during a waited transfer, with an IDLE transfer, fails in some clk cycles when HREADY = 0, passed in display
// `include "test_case16.sv"      // ERROR response test, fails, verify it from waveform
// `include "test_case17.sv"      // write address phase, wait, write data phase then read
// `include "random_test.sv"
// make one for HRESETn, it does not pass
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
    #5 HRESETn = 1;
  end
  
  //DUT instance, interface signals are connected to the DUT ports
  ahb3lite_sram1rw #(
    .MEM_SIZE      (`MEM_SIZE),
    .HADDR_SIZE    (`HADDR_SIZE),
    .HDATA_SIZE    (`HDATA_SIZE)
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