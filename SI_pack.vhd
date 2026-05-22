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
	 
	 constant pc_X_START_SS_BORDER  :   integer     :=pc_X_START_BORDER + 10;
    constant pc_X_END_SS_BORDER    :   integer     :=pc_X_END_BORDER - 10;

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
    
    
    --parameter of invaders
	 constant pc_X_START_INVS_BORDER :  integer     :=35;
	constant pc_INV_WIDTH           :  integer     :=16;
    constant pc_INV_HEIGHT          :  integer     :=8;
	constant pc_SPACE               :  integer     :=2;  --space between horizontal and vertical invaders
	constant pc_INV_LIMIT           :  integer     :=20;
    constant pc_INV_ROW1_LIMIT      :  integer     :=5;                     --5
    constant pc_INV_ROW2_LIMIT      :  integer     :=pc_INV_ROW1_LIMIT + 5; --10
    constant pc_INV_ROW3_LIMIT      :  integer     :=pc_INV_ROW2_LIMIT + 5; --15
    constant pc_INV_ROW4_LIMIT      :  integer     :=pc_INV_ROW3_LIMIT + 5; --20
    constant pc_Y_INV_ROW1          :  integer     :=pc_Y_START_BORDER + 10;
    constant pc_Y_INV_ROW2          :  integer     :=pc_Y_INV_ROW1 + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_Y_INV_ROW3          :  integer     :=pc_Y_INV_ROW2 + (pc_INV_HEIGHT) + pc_SPACE;
    constant pc_Y_INV_ROW4          :  integer     :=pc_Y_INV_ROW3 + (pc_INV_HEIGHT) + pc_SPACE;
	 
	 constant pc_X_INV_COL1          :  integer     :=pc_X_START_INVS_BORDER;
    constant pc_X_INV_COL2          :  integer     :=pc_X_INV_COL1 + (pc_INV_WIDTH) + pc_SPACE;
    constant pc_X_INV_COL3          :  integer     :=pc_X_INV_COL2 + (pc_INV_WIDTH) + pc_SPACE;
    constant pc_X_INV_COL4          :  integer     :=pc_X_INV_COL3 + (pc_INV_WIDTH) + pc_SPACE;
	 constant pc_X_INV_COL5          :  integer     :=pc_X_INV_COL4 + (pc_INV_WIDTH) + pc_SPACE;
    
    --hearts
    constant pc_H_WIDTH     :   integer     :=7;
    constant pc_H_HEIGHT    :   integer     :=6;
    constant pc_Y_START_HEART :  integer     :=5;
    constant pc_Y_END_HEART :  integer     :=pc_Y_START_HEART + pc_H_HEIGHT;
    constant pc_X_START_H1 :  integer     :=133;
    constant pc_X_END_H1 :  integer     :=pc_X_START_H1 + pc_H_WIDTH;
    constant pc_X_START_H2 :  integer     :=141;
    constant pc_X_END_H2 :  integer     :=pc_X_START_H2 + pc_H_WIDTH;
    constant pc_X_START_H3 : integer        :=149;
    constant pc_X_END_H3 :  integer         :=pc_X_START_H3 + pc_H_WIDTH;

    --ufo
    constant pc_UFO_WIDTH   :   integer     :=16;
    constant pc_UFO_HEIGHT  :   integer     :=8;
    constant pc_Y_START_UFO :   integer     :=11;
    constant pc_Y_END_UFO   :   integer     :=pc_Y_START_UFO + pc_UFO_HEIGHT;
    



    --parameters of speed
    constant pc_SS_SPEED        :   integer     :=500000;  --0.04 Sec (with 25MHz CLK)
    constant pc_BULLET_SPEED    :   integer     :=200000;  
    constant pc_INVS_SPEED      :   integer     :=2000000;  --0.08 Sec (with 25MHz CLK)
    constant pc_BURST_SPEED     :   integer     :=1500000; 
	 constant pc_INV_FRAME_SPEED 		:	integer     :=25000000; --1 sec
     constant pc_TIME_BETWEEN_POISONS:  integer     :=25000000; --1 sec
     constant pc_POISON_SPEED       :   integer     :=500000;
     constant pc_SS_FRAME_SPEED 		:	integer     :=pc_BURST_SPEED;
     constant pc_LOOSE_TIME             :   integer     :=25000000; --1 sec
     constant pc_UFO_SPEED              :   integer     :=1000000; --fast


    type pt_object_spicification is record
        X       :   integer;
        Y       :   integer;
        ACTIVE  :   STD_LOGIC;
    end record;
    type pt_bullets_pack is array (0 to pc_BULLET_LIMIT -1) of pt_object_spicification;
    type pt_invaders_pack is array(0 to pc_INV_LIMIT -1) of pt_object_spicification;
    type ROM5_15 is array (0 to 4) of unsigned(0 to 14);
    type ROM8_16 is array (0 to 7) of unsigned(0 to 15);
    type ROM6_7 is array (0 to 5) of unsigned(0 to 6);


    constant pc_space_sheep   :  ROM5_15 :=(
        "000000010000000",
        "000000111000000",
        "001111111111100",
        "111111111111111",
        "111111111111111"
    );

    constant pc_dead_SS_f1   :  ROM5_15 :=(
        "001010010100001",
        "000101001001001",
        "010001111001010",
        "100011111111100",
        "001111111111110"
    );

    constant pc_dead_SS_f2   :  ROM5_15 :=(
        "100101000100100",
        "011010010100100",
        "100001111000011",
        "010011111111101",
        "001111111111110"
    );

    constant pc_invader_1_f1  :  ROM8_16  :=(
        "0000100000110000",
        "0001111111111000",
        "0011111111111100",
        "0011000110001100",
        "0111111111111110",
        "1111100000011111",
        "1111111111111111",
        "1101100110110011"
    );

    constant pc_invader_1_f2  :  ROM8_16  :=(
        "0000100000110000",
        "0001111111111000",
        "0011111111111100",
        "0011101111011100",
        "0111111111111110",
        "1111111001111111",
        "1111111111111111",
        "1010011001001101"
    );

    constant pc_invader_2_f1  :  ROM8_16  :=(
        "0000111111110000",
        "0001110110111000",
        "1001111111111001",
        "1001000000001001",
        "1111001001011111",
        "0001111111111000",
        "0000110000110000",
        "0001000000001000"
    );

    constant pc_invader_2_f2  :  ROM8_16  :=(
        "0000111111110000",
        "0001110110111000",
        "0001110110111000",
        "0001111111111000",
        "1111100000011111",
        "1001111111111001",
        "1000110000110001",
        "0000100000010000"
    );

    constant pc_invader_3_f1  :  ROM8_16  :=(
        "0000110000110000",
        "0000111111110000",
        "0011111111111100",
        "1111001111001111",
        "1111111111111111",
        "0000110000110000",
        "0011001111001100",
        "1100110000110011"
    );

    constant pc_invader_3_f2  :  ROM8_16  :=(
        "0000011001100000",
        "0000111111110000",
        "0011111111111100",
        "1111101111101111",
        "1111111111111111",
        "0001100110011000",
        "0011011001101100",
        "0100100110010010"
    );

    constant pc_invader_4_f1  :  ROM8_16  :=(
        "0000100000010000",
        "0000011001100000",
        "0000111111110000",
        "0001100110011000",
        "1111100110011111",
        "1101111111111011",
        "1100111111110011",
        "0000111001110000"
    );

    constant pc_invader_4_f2  :  ROM8_16  :=(
        "0000100000010000",
        "0000011001100001",
        "0000111111110011",
        "0001100110011011",
        "1111111111111111",
        "1101100000011000",
        "1100111111110000",
        "0000111001110000"
    );

    constant pc_UFO :  ROM8_16  :=(
        "0000001111000000",
        "0000011111100000",
        "0001111111111000",
        "0011001001001100",
        "0111111111111110",
        "1111111111111111",
        "0011100110011100",
        "0001000000001000"
    );  

    constant pc_burst   :   ROM8_16     :=(
        "0110100110010000",
        "0010110010110000",
        "0011011000110110",
        "0000001000101100",
        "0111100000001110",
        "0100100100110100",
        "0001101101011000",
        "0001001011001100"
        
    );


    constant pc_heart   :  ROM6_7   :=(
        "0110110",
        "1111111",
        "1111111",
        "0111110",
        "0011100",
        "0001000"
    );

constant pc_initial_invaders  :  pt_invaders_pack :=(
    0 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '1'
    ),
    1 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '1'
    ),
    2 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '1'
    ),
    3 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '1'
    ),
    4 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '1'
    ),

    5 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '1'
    ),
    6 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '1'
    ),
    7 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '1'
    ),
    8 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '1'
    ),
    9 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '1'
    ),

    10 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '1'
    ),
    11 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '1'
    ),
    12 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '1'
    ),
    13 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '1'
    ),
    14 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '1'
    ),
    
    15 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '1'
    ),
    16 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '1'
    ),
    17 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '1'
    ),
    18 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '1'
    ),
    19 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '1'
    )
);


constant pc_initial_poisons  :  pt_invaders_pack :=(
    0 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '0'
    ),
    1 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '0'
    ),
    2 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '0'
    ),
    3 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '0'
    ),
    4 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW1,
        ACTIVE => '0'
    ),

    5 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '0'
    ),
    6 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '0'
    ),
    7 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '0'
    ),
    8 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '0'
    ),
    9 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW2,
        ACTIVE => '0'
    ),

    10 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '0'
    ),
    11 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '0'
    ),
    12 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '0'
    ),
    13 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '0'
    ),
    14 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW3,
        ACTIVE => '0'
    ),
    
    15 => (
        X => pc_X_INV_COL1,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '0'
    ),
    16 => (
        X => pc_X_INV_COL2,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '0'
    ),
    17 => (
        X => pc_X_INV_COL3,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '0'
    ),
    18 => (
        X => pc_X_INV_COL4,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '0'
    ),
    19 => (
        X => pc_X_INV_COL5,
        Y => pc_Y_INV_ROW4,
        ACTIVE => '0'
    )
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



