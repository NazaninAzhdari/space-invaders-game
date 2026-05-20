library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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

    constant    pc_GAME_WIDTH      :   integer     :=160;              --640/4=160
    constant    pc_GAME_HEIGHT     :   integer     :=120;              --480/4=120
    constant    pc_GAME_BITS       :   integer     :=pc_VGA_BITS - 2;  --dividing by 4 will drop 2 bits, only 8 bits remains
	constant    pc_DEBOUNCE_LIMIT  :   integer     :=250000;           --5 milli Sec (with 50MHZ CLK)

    --border parameters
    constant pc_X_START_BORDER  :   integer     :=5;
    constant pc_X_END_BORDER    :   integer     :=155;
    constant pc_X_MIDDLE_BORDER :   integer     :=80;
    constant pc_Y_START_BORDER  :   integer     :=10;
    constant pc_Y_END_BORDER    :   integer     :=110;

    --parameters of Space-sheep
    
    constant pc_Y_START_SS      :   integer     :=106;
    constant pc_Y_END_SS        :   integer     :=pc_Y_END_BORDER;
    constant pc_SS_HEIGHT       :   integer     :=5;
    constant pc_SS_WIDTH        :   integer     :=15;
	constant pc_X_INITIAL_SS    :   integer     :=pc_X_MIDDLE_BORDER - (pc_SS_WIDTH/2);

    --parameters of bullets
	constant pc_X_START_BULLET  :   integer     :=pc_X_MIDDLE_BORDER;
    constant pc_Y_START_BULLET  :   integer     :=pc_Y_START_SS;
    constant pc_BULLET_LIMIT    :   integer     :=8;
    type pt_bullets is record
        X       :   integer;
        Y       :   integer;
        ACTIVE  :   STD_LOGIC;
    end record;
    type pt_bullets_pack is array (0 to pc_BULLET_LIMIT -1) of pt_bullets;
 
    
    --parameter of invaders
	constant pc_INV_WIDTH           :  integer     :=16;
    constant pc_INV_HEIGHT          :  integer     :=8;
	constant pc_SPACE               :  integer     :=2;  --space between horizontal and vertical invaders
	constant pc_INV_LIMIT           :  integer     :=20;
    constant pc_INV_ROW1_LIMIT      :  integer     :=5;                     --5
    constant pc_INV_ROW2_LIMIT      :  integer     :=pc_INV_ROW1_LIMIT + 5; --10
    constant pc_INV_ROW3_LIMIT      :  integer     :=pc_INV_ROW2_LIMIT + 5; --15
    constant pc_INV_ROW4_LIMIT      :  integer     :=pc_INV_ROW3_LIMIT + 5; --20
    constant pc_Y_INV_ROW1          :  integer     :=pc_Y_START_BORDER;
    constant pc_Y_INV_ROW2          :  integer     :=pc_Y_START_BORDER + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_Y_INV_ROW3          :  integer     :=pc_Y_INV_ROW2 + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_Y_INV_ROW4          :  integer     :=pc_Y_INV_ROW3 + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_X_START_INVS_BORDER :  integer     :=35;
    type pt_invaders is record
        X     :   integer;
        Y     :   integer;
        ALIVE :   STD_LOGIC;
    end record;
    type pt_invaders_pack is array(0 to pc_INV_LIMIT -1) of pt_invaders;
  
    
    --parameters of speed
    constant pc_SS_SPEED        :   integer     :=1000000;  --0.04 Sec (with 25MHz CLK)
    constant pc_BULLET_SPEED    :   integer     :=2500000;  --0.1 Sec (with 25MHz CLK)
    constant pc_INVS_SPEED      :   integer     :=2000000;  --0.08 Sec (with 25MHz CLK)


    type ROM5_15 is array (0 to 4) of unsigned(0 to 14);
    type ROM8_16 is array (0 to 7) of unsigned(0 to 15);

    constant pc_space_sheep   :  ROM5_15 :=(
        "000000010000000",
        "000000111000000",
        "001111111111100",
        "111111111111111",
        "111111111111111"
    );

    constant pc_invader_1  :  ROM8_16  :=(
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



