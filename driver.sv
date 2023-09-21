`define DRIV_IF vif.DRIVER.driver_cb
class driver;
  
    int no_transactions;                    //used to count the number of transactions
    virtual ahb3lite_bus_inf vif;               //creating virtual interface handle
    mailbox gen2driv;                       //creating mailbox handle
    
    //event drv_done;
  //constructor
    function new(input virtual ahb3lite_bus_inf vif, input mailbox gen2driv); //, input event drv_done);
        this.vif = vif;       //getting the interface
        this.gen2driv = gen2driv;     //getting the mailbox handles from  environment
        //this.drv_done = drv_done;
        //trans = new();
    endfunction
  
    //Reset task, Reset the Interface signals to default/initial values
    task reset;
        wait(!vif.HRESETn);
        $display("--------- [DRIVER] Reset Started ---------");  
        `DRIV_IF.HSEL <= 0;
        `DRIV_IF.HADDR <= 0;
        `DRIV_IF.HWDATA <= 0;
        `DRIV_IF.HWRITE <= 0;
        `DRIV_IF.HSIZE <= 0;
        `DRIV_IF.HBURST <= 0;
        `DRIV_IF.HPROT <= 0;
        `DRIV_IF.HTRANS <= 0;   
        `DRIV_IF.HREADY <= 0;     
        wait(vif.HRESETn);
        $display("--------- [DRIVER] Reset Ended ---------");
    endtask
  
  //drivers the transaction items to interface signals
    task drive;
        transaction trans;
        gen2driv.get(trans);
        @(posedge vif.DRIVER.HCLK);
        `DRIV_IF.HADDR <= trans.HADDR;
        `DRIV_IF.HSEL <= trans.HSEL; // 1;
        `DRIV_IF.HSIZE <= trans.HSIZE; // 2;
        `DRIV_IF.HPROT <= trans.HPROT;
        `DRIV_IF.HTRANS <= trans.HTRANS; //2; 
        `DRIV_IF.HBURST <= trans.HBURST; // 0;
        `DRIV_IF.HWRITE <= trans.HWRITE; //1;
        `DRIV_IF.HREADY <= trans.HREADY; //1;
        if (trans.HWRITE && trans.HREADY) begin
            @(posedge vif.DRIVER.HCLK);
            `DRIV_IF.HWDATA <= trans.HWDATA;
        end
        no_transactions++;
        $display("[Driver]: Value recieved in driver. Transaction: %d", no_transactions);
        //trans.print_trans();
        // -> drv_done;
    endtask

    task main;
        forever begin
            fork
                //Thread-1: Waiting for reset
            // begin
            //   wait(!mem_vif.reset);
            // end
        //Thread-2: Calling drive task
            begin
                forever
                    drive();
            end
            join_any
            disable fork;
        end
    endtask
        
endclass

