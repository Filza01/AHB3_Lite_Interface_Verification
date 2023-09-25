class c_9_2;
    rand bit[15:0] HADDR = 16'h1f; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h2; // rand_mode = OFF 

    constraint C_HADDR_align_with_HSIZE_this    // (constraint_mode = ON) (transaction.sv:23)
    {
       ((!(HSIZE == 3'h1)) && (HSIZE == 3'h2)) -> ((HADDR % 4) == 0);
    }
endclass

program p_9_2;
    c_9_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "100z0x1xzx0x11zxz0z1zxz0xxz00000xzzxzxxzxxxxzzxzzxxzxzxxxxxxxzzz";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
