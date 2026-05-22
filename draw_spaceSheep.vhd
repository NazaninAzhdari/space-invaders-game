library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_spaceSheep is
    port (
	    i_clk		    :	in 		STD_LOGIC;
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_x_start_SS    :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_loose_live_en :   in      STD_LOGIC;
        o_draw_SS       :   out     STD_LOGIC
    );
end draw_spaceSheep;

architecture RTL of draw_spaceSheep is
    signal r_x              :   integer range 0 to pc_GAME_WIDTH -1                  :=0;
    signal r_y              :   integer range 0 to pc_GAME_HEIGHT -1                 :=0;
    signal r_x_start_SS     :   integer range pc_X_START_BORDER to pc_X_END_BORDER   :=pc_X_INITIAL_SS;
	signal r_x_end_SS       :   integer range pc_X_START_BORDER to pc_X_END_BORDER   :=pc_X_INITIAL_SS + pc_SS_WIDTH -1;
    signal r_frame          :   STD_LOGIC                                            :='0';
    signal r_frame_counter  :   integer range 0 to pc_SS_FRAME_SPEED                 :=0;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);
        r_x_start_SS <= to_integer(i_x_start_SS);
        r_x_end_SS <= r_x_start_SS + pc_SS_WIDTH -1;

        --------------------------------------------------------------------------------------------------------
        --Drawing Space-sheep at the spicific location
        --The shape of space-sheep changes when it collide with poisons.
        --------------------------------------------------------------------------------------------------------
        o_draw_SS <= pc_space_sheep(r_y - pc_Y_START_SS)(r_x - r_x_start_SS) when i_loose_live_en = '0'
                                                    and r_y >= pc_Y_START_SS and r_y <= pc_Y_END_SS 
                                                    and r_x >= r_x_start_SS and r_x <= r_x_end_SS else
                    pc_dead_SS_f1(r_y - pc_Y_START_SS)(r_x - r_x_start_SS) when i_loose_live_en = '1' and r_frame = '0'
                                                    and r_y >= pc_Y_START_SS and r_y <= pc_Y_END_SS 
                                                    and r_x >= r_x_start_SS and r_x <= r_x_end_SS else
                    pc_dead_SS_f2(r_y - pc_Y_START_SS)(r_x - r_x_start_SS) when i_loose_live_en = '1' and r_frame = '1'
                                                    and r_y >= pc_Y_START_SS and r_y <= pc_Y_END_SS 
                                                    and r_x >= r_x_start_SS and r_x <= r_x_end_SS
                                                    else '0';

        ------------------------------------------------------------------------
        --Logic for changing the frame when we are in the loosing lives state.
        ------------------------------------------------------------------------
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if i_loose_live_en = '1' then
                        if r_frame_counter < pc_SS_FRAME_SPEED then
                            r_frame_counter <= r_frame_counter + 1;
                        else
                            r_frame_counter <= 0;
                            r_frame <= not r_frame;
                        end if;
                    end if;
                end if;
            end process;

    end RTL;