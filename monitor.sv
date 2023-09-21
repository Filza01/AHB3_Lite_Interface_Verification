`define MON_IF vif.MONITOR.monitor_cb
class monitor;
    
    virtual ahb3lite_bus_inf vif;                //creating virtual interface handle
    mailbox mon2scb;                     //creating mailbox handle
    
    //event drv_done;
  
    //constructor
    function new(input virtual ahb3lite_bus_inf vif, input mailbox mon2scb); //input event drv_done);
        this.vif = vif;             //getting the interface
        this.mon2scb = mon2scb;     //getting the mailbox handles from  environment 
        //this.drv_done = drv_done;
    endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
    task main;
        forever begin
            transaction t;
            t = new();
            @(posedge vif.MONITOR.HCLK);
            //wait(vif.MONITOR.HRESETn);
            t.HSEL = `MON_IF.HSEL;
            t.HADDR = `MON_IF.HADDR;
            t.HWRITE = `MON_IF.HWRITE;
            t.HSIZE = `MON_IF.HSIZE;
            t.HBURST = `MON_IF.HBURST;
            t.HPROT = `MON_IF.HPROT;
            t.HTRANS = `MON_IF.HTRANS;
            t.HREADY = `MON_IF.HREADY;
            if (`MON_IF.HWRITE && `MON_IF.HREADY) begin
                @(posedge vif.MONITOR.HCLK);
                t.HWDATA = `MON_IF.HWDATA;
            end
            else begin
                @(posedge vif.MONITOR.HCLK);
                t.HREADYOUT = `MON_IF.HREADYOUT;
                t.HRDATA = `MON_IF.HRDATA;
                t.HRESP = `MON_IF.HRESP;
            end
            mon2scb.put(t);
            $display("[Monitor] Data passed to scoreboard.");
            //$display("reset = %d", vif.HRESETn);
            //t.print_trans();
        end
    endtask
  
endclass