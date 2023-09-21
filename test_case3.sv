`include "environment.sv"
program test(ahb3lite_bus_inf intf);
  
  class my_trans extends transaction;
    bit [2:0] count;

    function void pre_randomize();
        //$display("turn rand mode off");
      HADDR.rand_mode(0);
      HSEL.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HBURST.rand_mode(0);
      HREADY.rand_mode(0);
      HWRITE.rand_mode(0);
      HWDATA.rand_mode(0);
      HSEL = 1;
      HSIZE = 2;
      HTRANS = 2;
      HBURST = 0;

      if (count == 1) begin
        HWDATA = 32'ha;
        HADDR = 4;
        HWRITE = 1;
        HREADY = 1;
      end
      else if (count == 2) begin
        HWDATA = 32'hb;
        HADDR = 8;
        HWRITE = 0;
        HREADY = 1;
      end
      else if (count == 3) begin
        HWDATA = 32'hc;
        HADDR = 12;
        HWRITE = 1;
        HREADY = 0;
      end
      else if (count == 4) begin
        HWDATA = 32'hc;
        HADDR = 12;
        HWRITE = 1;
        HREADY = 1;
      end
      else if (count == 7) begin
        HWDATA = 32'h0;
        HADDR = 12;
        HWRITE = 1;
        HREADY = 1;
        count = 0;
      end
      else begin
        HWDATA = 32'h0;
        HADDR = 0;
        HWRITE = 1;
        HREADY = 1;
      end
      count++;

      //print_trans();
      //$display("pre rand done");

    //   if (count % 2 == 0) begin
    //     HADDR = count*2;
    //     HWRITE = 1;
    //    // HREADY = 1;
    //   end
    //   else begin
    //     HWRITE = 0;
    //    // HREADY = 0;
    //   end
    //   count++;
    
    //   if(cnt % 2 == 0) begin
    //     //$display("make hready 0");
    //     HREADY = 0;
    //   end
    //   else begin
    //     //$display("make hready 1");
    //     HREADY = 1;
    //   end
    //  cnt++;

    endfunction
  endclass

  //declaring environment instance
  environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(intf);
    my_tr = new();
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 10;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram