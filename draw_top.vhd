library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_top is
    port (
        i_clk               :   in      STD_LOGIC;
        i_x                 :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y                 :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_DE                :   in      STD_LOGIC;
        i_start_en          :   in      STD_LOGIC;
        i_run_en            :   in      STD_LOGIC;
        i_loose_live_en     :   in      STD_LOGIC;
        i_win_en            :   in      STD_LOGIC;
        i_end_en            :   in      STD_LOGIC;
        i_UFO_active        :   in      STD_LOGIC;
        i_x_start_UFO       :   in      signed(pc_GAME_BITS downto 0);
        i_x_start_SS        :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_bullets           :   in      pt_bullets_pack;
        i_invaders          :   in      pt_invaders_pack;
        i_poisons           :   in      pt_invaders_pack;
        i_lives             :   in      integer;
        o_drawing_data_bus  :   out     unsigned(23 downto 0)
    );
end draw_top;

architecture RTL of draw_top is
    signal w_draw_invaders      :   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');
    signal w_draw_bullets       :   unsigned(pc_BULLET_LIMIT -1 downto 0)   :=(others=>'0');
    signal w_draw_SS            :   STD_LOGIC                               :='0';
    signal w_draw_burst_invaders:   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');
    signal w_draw_poisons       :   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');
    signal w_draw_hearts        :   STD_LOGIC                               :='0';
    signal w_draw_ufo           :   STD_LOGIC                               :='0';
    signal w_draw_SI_txt        :   STD_LOGIC                               :='0';
    signal w_draw_GO_txt        :   STD_LOGIC                               :='0';
    signal w_draw_WIN_txt       :   STD_LOGIC                               :='0';
    signal r_run, r_start, r_end, r_win:   unsigned(23 downto 0)            :=(others=>'0');

    constant c_20bit_zero       :   unsigned(pc_INV_LIMIT-1 downto 0)       :=(others=>'0');
	constant c_8bit_zero        :   unsigned(pc_BULLET_LIMIT-1 downto 0)    :=(others=>'0');

    

    begin
        -----------------------------------------
        --Draw Space-Sheep
        ----------------------------------------
        drawing_Space_Sheep: entity work.draw_spaceSheep
        port map(
		    i_clk => i_clk,
            i_x => i_x,
            i_y=> i_y,
            i_x_start_SS => i_x_start_ss,
            i_loose_live_en => i_loose_live_en,
            o_draw_SS =>w_draw_SS
        );

        ----------------------------------------
        --Draw Bullets
        ----------------------------------------
        drawing_bullets: entity work.draw_bullets
        port map(
            i_bullets => i_bullets,
            i_x => i_x,
            i_y => i_y,
            o_draw_bullets => w_draw_bullets
        );

        -----------------------------------------
        --Draw Invaders + Bursting Invaders
        -----------------------------------------
        drawing_invaders: entity work.draw_invaders
        port map(
            i_clk => i_clk,
            i_en => i_run_en,
            i_x => i_x,
            i_y => i_y,
            i_invaders => i_invaders,
            o_draw_invaders => w_draw_invaders,
            o_draw_burst_invaders => w_draw_burst_invaders
        );

        ---------------------------------------------
        --Draw Poisons
        ---------------------------------------------
        draw_poisons: entity work.draw_poisons
        port map(
            i_x => i_x,
            i_y => i_y,
            i_poisons => i_poisons,
            o_draw_poisons => w_draw_poisons
        );

        -----------------------------------------------
        --Draw Hearts
        -----------------------------------------------
        drawing_hearts: entity work.draw_hearts
        port map(
            i_x => i_x,
            i_y => i_y,
            i_lives =>i_lives,
            o_draw_hearts => w_draw_hearts
        );

        ------------------------------------------------
        --Draw UFO
        ------------------------------------------------
        drawing_ufo : entity work.draw_UFO
        port map(
            i_clk => i_clk,
            i_x => i_x,
            i_y => i_y,
            i_x_start_ufo => i_x_start_ufo,
            i_ufo_active => i_ufo_active,
            o_draw_UFO => w_draw_ufo
        );

        ------------------------------------------------
        --Draw Start Frame: Space Invaders Text
        ------------------------------------------------
        drawing_start_frame: entity work.draw_frame_start
        port map(
            i_x => i_x,
            i_y => i_y,
            o_draw_SI_txt => w_draw_SI_txt
        );

        ------------------------------------------------
        --Draw End Frame: Game Over Text
        ------------------------------------------------
        drawing_game_over_txt: entity work.draw_frame_gameover
        port map(
            i_x => i_x,
            i_y => i_y,
            o_draw_GO_txt => w_draw_GO_txt
        );

        ------------------------------------------------
        --Draw Winning Frame: Winner Text
        ------------------------------------------------
        drawing_winning_txt: entity work.draw_frame_win
        port map(
            i_x => i_x,
            i_y => i_y,
            o_draw_WIN_txt => w_draw_WIN_txt
        );



        r_run <= (others=>'0') when i_de = '1' and (i_run_EN = '1' or i_loose_live_en = '1')
                                        (w_draw_SS = '1' or w_draw_hearts = '1' or w_draw_invaders /=c_20bit_zero 
                                        or w_draw_bullets /=c_8bit_zero or w_draw_burst_invaders /= c_20bit_zero
                                        or w_draw_poisons /=c_20bit_zero or w_draw_ufo = '1') else
                            (others=>'1') when i_de = '1' else
                            (others=>'0');
        
        r_start <=(others=>'0') when i_de = '1' and i_start_EN = '1' and w_draw_SI_txt = '1' else 
                (others=>'1') when i_de = '1' else
                 (others=>'0');

        r_end <= (others=>'0') when i_de = '1' and i_end_EN = '1' and w_draw_GO_txt = '1' else 
                (others=>'1') when i_de = '1' else
                (others=>'0');

        r_win <= (others=>'0') when i_de = '1' and i_win_EN = '1' and w_draw_WIN_txt = '1' else 
                (others=>'1') when i_de = '1' else
                (others=>'0');
        
        o_drawing_data_bus <= r_run or r_start or r_end or r_win;

    end RTL;