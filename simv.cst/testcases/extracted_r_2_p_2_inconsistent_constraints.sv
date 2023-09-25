class c_2_2;
    rand bit[15:0] HADDR = 16'h43; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h2; // rand_mode = OFF 

    constraint C_HADDR_align_with_HSIZE_this    // (constraint_mode = ON) (transaction.sv:23)
    {
       ((!(HSIZE == 3'h1)) && (HSIZE == 3'h2)) -> ((HADDR % 4) == 0);
    }
endclass

program p_2_2;
    c_2_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x0xx010x1z1xzz1z11zzz0x1xzx0xxx0xxxzzzxxzxzxxzzxzxxzxxxxzzxzzxxz";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
