class scoreboard;
    mailbox mon2scb;                 //creating mailbox handle
    int no_transactions;             //used to count the number of transactions
    logic [31:0] memory_temp [256];
    
    //constructor
    function new(input mailbox mon2scb);
      this.mon2scb = mon2scb;     //getting the mailbox handles from  environment
      foreach(memory_temp[i]) memory_temp[i] = 32'dX;
    endfunction
    
    //stores wdata and compare rdata with stored data
    task main;
        transaction trans;
        forever begin
            //#50;
            mon2scb.get(trans);
            
            $display("[Scoreboard] Data successfully recieved in scoreboard");
            if (trans.HWRITE && trans.HSEL) begin
              case (trans.HSIZE)
                3'b000 : memory_temp[trans.HADDR] = {24'dx,trans.HWDATA[7:0]};
                3'b001 : memory_temp[trans.HADDR] = {16'dx,trans.HWDATA[15:0]};
                3'b010 : memory_temp[trans.HADDR] = trans.HWDATA;
                default : memory_temp[trans.HADDR] = 32'dx;
              endcase
            end
            else begin
              if (memory_temp[trans.HADDR] !==  trans.HRDATA) begin
                $display("[SCB-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR],trans.HRDATA);
              end
              else begin
                $display("[SCB-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR],trans.HRDATA);
              end
            end
            no_transactions++;
            //trans.print_trans();
        end
    endtask
    
  endclass