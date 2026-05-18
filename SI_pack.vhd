package SI_pack is
    function pf_log2ceil(value:    integer) return integer;
    
    --parameters of VGA 640*480 @ 60Hz timing
    --horizontal parameters
    constant    pc_H_ACTIVE    :   integer     :=640;
    constant    pc_H_FP        :   integer     :=16;
    constant    pc_H_SYNC      :   integer     :=96;
    constant    pc_H_BP        :   integer     :=48;
    constant    pc_H_TOTAL     :   integer     :=pc_H_ACTIVE + pc_H_FP + pc_H_SYNC + pc_H_BP;
    --vertical parameters
    constant    pc_V_ACTIVE    :   integer     :=480;
    constant    pc_V_FP        :   integer     :=10;
    constant    pc_V_SYNC      :   integer     :=2;
    constant    pc_V_BP        :   integer     :=33;
    constant    pc_V_TOTAL     :   integer     :=pc_V_ACTIVE + pc_V_FP + pc_V_SYNC + pc_V_BP; 
    constant    pc_VGA_BITS    :   integer     :=pf_log2ceil(pc_H_TOTAL);  --10 bits


end package;

package body SI_pack is

    function pf_log2ceil(value:    integer) return integer is
        variable    v_number          :   integer :=value-1;
        variable    v_bit_counter     :   integer :=0;
        begin
            while v_number > 0 loop
                v_number := v_number / 2;
                v_bit_counter := v_bit_counter + 1;
            end loop;
            return v_bit_counter;
        end function;

end package body;