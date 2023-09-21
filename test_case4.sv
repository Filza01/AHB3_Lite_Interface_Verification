`include "environment.sv"
program test(ahb3lite_bus_inf intf);
  
  class my_trans extends transaction;
    bit [2:0] count;

    function void pre_randomize();
      HADDR.rand_mode(0);
      HSEL.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HBURST.rand_mode(0);
      HREADY.rand_mode(0);
      HWRITE.rand_mode(0);
      HSEL = 1;
      HSIZE = 2;
      HBURST = 0;
      HREADY = 1;

      if (count == 1) begin
        HADDR = 4;
        HWRITE = 1;
        HTRANS = 0;
      end
      else if (count == 2) begin
        HADDR = 4;
        HWRITE = 1;
        HTRANS = 1;
      end
      else if (count == 3) begin
        HADDR = 4;
        HWRITE = 1;
        HTRANS = 2;
      end
      else if (count == 4) begin
        HADDR = 4;
        HWRITE = 0;
        HTRANS = 0;
      end
      else if (count == 5) begin
        HADDR = 4;
        HWRITE = 0;
        HTRANS = 1;
      end
      else if (count == 6) begin
        HADDR = 4;
        HWRITE = 0;
        HTRANS = 1;
      end
      else if (count == 7) begin
        HADDR = 4;
        HWRITE = 0;
        HTRANS = 2;
      end
      else begin
        HADDR = 4;
        HWRITE = 1;
        HTRANS = 0;
      end
      count++;

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