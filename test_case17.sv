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
      HWDATA.rand_mode(0);
      HSEL = 1;
      HTRANS = 2;
      HBURST = 0;
      HSIZE = 2;

      case (count)
        0 : begin
                HADDR = 16'h4;
                HWRITE = 1;
                HREADY = 1;
                HWDATA = 32'h92392;
            end
        1 : begin
                HADDR = 16'h8;
                HWRITE = 1;
                HREADY = 0;
                HWDATA = 32'h23f4d;
            end
        2 : begin
                HADDR = 16'h8;
                HWRITE = 1;
                HREADY = 0;
                HWDATA = 32'h23f4d;
            end
        3 : begin
                HADDR = 16'h8;
                HWRITE = 1;
                HREADY = 1;
                HWDATA = 32'h232342;
            end
        4 : begin
                HADDR = 16'h8;
                HWRITE = 1;
                HWDATA = 32'haa4d;
                HREADY = 1;
            end
        5 : begin
                HADDR = 16'h4;
                HWRITE = 0;
                HWDATA = 32'h223239d;
                HREADY = 1;
            end
        6 : begin
                HADDR = 16'h8;
                HWRITE = 0;
                HREADY = 1;
            end
      endcase

      if (count == 8) count = 0;

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
    env.gen.repeat_count = 8;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram