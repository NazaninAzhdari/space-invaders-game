library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_spaceSheep is
    port (
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_x_start_SS    :   in      unsigned(pc_GAME_BITS-1 downto 0);
        o_draw_SS       :   in      STD_LOGIC
    );
end draw_spaceSheep;

architecture RTL of draw_spaceSheep is
    signal r_x          :   integer range 0 to pc_GAME_WIDTH -1                  :=0;
    signal r_y          :   integer range 0 to pc_GAME_HEIGHT -1                 :=0;
    signal r_x_start_SS :   integer range pc_X_START_BORDER to pc_X_END_BORDER   :=pc_xMIDDLE_BORDER;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);
        r_x_start_SS <= to_integer(r_x_start_SS);

        r_x_end_SS <= r_x_start_SS + pc_SS_WIDTH -1;

        o_draw_SS <= pc_space_sheep(r_y - pc_Y_START_SS)(r_x - r_x_start_SS) when r_y >= pc_Y_START_SS and r_y <= pc_Y_END_SS 
                                                    and r_x >= r_x_start_SS and r_x <= r_x_end_SS
                                                    else '0';

    end RTL;