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

    --game parameters
    constant pc_GAME_WIDTH      :   integer     :=160;  --640/4
    constant pc_GAME_HEIGHT     :   integer     :=120;  --480/4
    constant pc_GAME_BITS       :   integer     :=pc_VGA_BITS - 2;  --dividing by 4 drops two bits

    --border parameters
    constant pc_X_START_BORDER  :   integer     :=5;
    constant pc_X_END_BORDER    :   integer     :=155;
    constant pc_X_MIDDLE_BORDER :   integer     :=80;
    constant pc_Y_START_BORDER  :   integer     :=10;
    constant pc_Y_END_BORDER    :   integer     :=110;

    --parameters of Space-sheep
    constant pc_X_INITIAL_SS    :   integer     :=pc_X_MIDDLE_BORDER - (pc_SS_WIDTH/2);
    constant pc_Y_START_SS      :   integer     :=95;
    constant pc_Y_END_SS        :   integer     :=pc_Y_END_BORDER;
    constant pc_SS_HEIGHT       :   integer     :=5;
    constant pc_SS_WIDTH        :   integer     :=15;

    --parameters of bullets
    type pt_bullets is record
        X       :   integer;
        Y       :   integer;
        ACTIVE  :   STD_LOGIC;
    end record;
    type pt_bullets_pack is array (0 to pc_BULLET_LIMIT -1) of pt_bullets;
    type pt_drawing_bullets is (0 to pc_BULLET_LIMIT -1) of STD_LOGIC;
    constant pc_X_START_BULLET  :   integer     :=pc_X_MIDDLE_BORDER;
    constant pc_Y_START_BULLET  :   integer     :=pc_Y_START_SS;
    constant pc_BULLET_LIMIT    :   integer     :=7;
    
    --parameter of invaders
    type pt_invaders is record
        X     :   integer;
        Y     :   integer;
        ALIVE       :   STD_LOGIC;
    end record;
    type pt_invaders_pack is (0 to pc_INV_LIMIT -1) of pt_invaders;
    type pt_drawing_invaders is (0 to pc_INV_LIMIT -1) of STD_LOGIC;
    constant pc_INV_LIMIT           :  integer     :=20;
    constant pc_INV_ROW1_LIMIT      :  integer     :=5;                     --5
    constant pc_INV_ROW2_LIMIT      :  integer     :=pc_INV_ROW1_LIMIT + 5; --10
    constant pc_INV_ROW3_LIMIT      :  integer     :=pc_INV_ROW2_LIMIT + 5; --15
    constant pc_INV_ROW4_LIMIT      :  integer     :=pc_INV_ROW3_LIMIT + 5; --20
    constant pc_Y_INV_ROW1          :  integer     :=pc_Y_START_BORDER;
    constant pc_Y_INV_ROW2          :  integer     :=pc_Y_START_BORDER + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_Y_INV_ROW3          :  integer     :=pc_Y_INY_ROW2 + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_Y_INV_ROW4          :  integer     :=pc_Y_INY_ROW3 + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_X_START_INVS_BORDER :  integer     :=35;
    constant pc_INV_WIDTH           :  integer     :=16;
    constant pc_INV_HEIGHT          :  integer     :=8;
    constant pc_SPACE               :  integer     :=2;  --space between horizontal and vertical invaders
    

    --parameters of speed
    constant pc_SS_SPEED        :   integer     :=--unknows
    constant pc_BULLET_SPEED    :   integer     :=--unknown
    constant pc_INVS_SPEED      :   integer     :=--unknown


    constant pc_X_START_INV
    constant pc_Y_START_INV :  integer   
    constant pc_INV_WIDTH
    constant pc_INV_HEIGHT : 




    
    

    




    
    

    constant pc_X_INV_COL1   :  integer
    constant pc_X_INV_COL2   :  integer
    constant pc_X_INV_COL3   :  integer
    constant pc_X_INV_COL4   :  integer
    constant pc_X_INV_COL5   :  integer



    type ROM5_15 is array (0 to 4) of unsigned(0 to 14);
    type ROM8_16 is array (0 to 7) of unsigned(0 to 15);

    constant space_sheep   :  ROM5_15 :(
        "000000010000000",
        "000000111000000",
        "001111111111100",
        "111111111111111",
        "111111111111111"
    );

    constant invader_1  :  ROM8_16  :=(
        "0000100000110000",
        "0001111111111000",
        "0011111111111100",
        "0011000110001100",
        "0111111111111110",
        "1111100000011111",
        "1111111111111111",
        "1101100110110011"
    );

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



