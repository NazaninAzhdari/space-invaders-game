library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_top is
    port (
        i_clk               :   in      STD_LOGIC;
        i_en                :   in      STD_LOGIC;
        i_loose_live_en     :   in      STD_LOGIC;
        i_lives             :   in      integer;
        i_x                 :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y                 :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_DE                :   in      STD_LOGIC;
        i_x_start_SS        :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_bullets           :   in      pt_bullets_pack;
        i_invaders          :   in      pt_invaders_pack;
        i_poisons           :   in      pt_invaders_pack;
        o_drawing_data_bus  :   out     unsigned(23 downto 0)
    );
end draw_top;

architecture RTL of draw_top is
    signal w_draw_invaders  :   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');

    signal w_draw_bullets   :   unsigned(pc_BULLET_LIMIT -1 downto 0)   :=(others=>'0');
    signal w_draw_SS        :   STD_LOGIC                               :='0';

    constant c_20bit_zero  :  unsigned(pc_INV_LIMIT-1 downto 0)     :=(others=>'0');
	constant c_8bit_zero   :  unsigned(pc_BULLET_LIMIT-1 downto 0)  :=(others=>'0');

    signal w_draw_burst_invaders  :   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');
    signal w_draw_poisons  :   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');
    signal w_draw_hearts  :  STD_LOGIC  :='0';
    begin
        -----------------------------------------
        --draw space sheep
        ----------------------------------------
        drawing_SS: entity work.draw_spaceSheep
        port map(
		  i_clk => i_clk,
            i_x => i_x,
            i_y=> i_y,
            i_x_start_SS => i_x_start_ss,
            i_loose_live_en => i_loose_live_en,
            o_draw_SS =>w_draw_SS
        );

        ----------------------------------------
        --draw bullets
        ----------------------------------------
        drawing_bullets: entity work.draw_bullets
        port map(
            i_bullets => i_bullets,
            i_x => i_x,
            i_y => i_y,
            o_draw_bullets => w_draw_bullets
        );

        -----------------------------------------
        --draw invaders
        -----------------------------------------
        drawing_invaders: entity work.draw_invaders
        port map(
            i_clk => i_clk,
            i_en => i_en,
            i_invaders => i_invaders,
            i_x => i_x,
            i_y => i_y,
            o_draw_invaders => w_draw_invaders,
            o_draw_burst_invaders => w_draw_burst_invaders
        );


        ---------------------------------------------
        --draw poisons
        ---------------------------------------------
        draw_poisons: entity work.draw_poisons
        port map(
            i_x => i_x,
            i_y => i_y,
            i_poisons => i_poisons,
            o_draw_poisons => w_draw_poisons
        );

        -----------------------------------------------
        --draw_hearts
        -----------------------------------------------
        drawing_hearts: entity work.draw_hearts
        port map(
            i_x => i_x,
            i_y => i_y,
            i_lives =>i_lives,
            o_draw_hearts => w_draw_hearts
        );


        o_drawing_data_bus <= (others=>'0') when i_de = '1' and 
                                        (w_draw_SS = '1' or w_draw_hearts = '1' or w_draw_invaders /=c_20bit_zero 
                                        or w_draw_bullets /=c_8bit_zero or w_draw_burst_invaders /= c_20bit_zero
                                        or w_draw_poisons /=c_20bit_zero) else
                            (others=>'1') when i_de = '1' else
                            (others=>'0');
    end RTL;