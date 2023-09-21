class c_1_2;
    rand bit[7:0] HADDR = 8'h3; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h2; // rand_mode = OFF 

    constraint C_HADDR_align_with_HSIZE_this    // (constraint_mode = ON) (transaction.sv:23)
    {
       ((!(HSIZE == 3'h1)) && (HSIZE == 3'h2)) -> ((HADDR % 4) == 0);
    }
endclass

program p_1_2;
    c_1_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xxx0001x00x00zzzzxxzz1xx101zx01xxxzzxzxzzzxxxzxzzzzzxxxxzxxxxxxx";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
