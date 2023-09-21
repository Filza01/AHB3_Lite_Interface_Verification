class c_1_1;
    rand bit[2:0] HBURST = 3'h1; // rand_mode = OFF 

    constraint C_HBURST_this    // (constraint_mode = ON) (transaction.sv:17)
    {
       (((HBURST == 3'h0) || (HBURST == 3'h2)) || (HBURST == 3'h3));
    }
endclass

program p_1_1;
    c_1_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "100z0x1xzx0x11zxz0z1zxz0xxz00000xzzxzxxzxxxxzzxzzxxzxzxxxxxxxzzz";
            obj.set_randstate(randState);
            obj.HBURST.rand_mode(0);
            obj.randomize();
        end
endprogram
