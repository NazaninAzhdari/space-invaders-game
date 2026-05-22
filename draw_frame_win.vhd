library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_frame_win is
    port (
        i_x                 :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y                 :   in      unsigned(pc_GAME_BITS-1 downto 0);
        o_draw_WIN_txt      :   out     STD_LOGIC
    );
end draw_frame_win;

architecture RTL of draw_frame_win is
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1  :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;

    constant c_X_START_BORDER  : integer :=8;
    constant c_Y_START_BORDER  : integer :=25;

    begin
        r_x <= to_integer(i_x(pc_GAME_BITS-1 downto 1)); --divided by two
        r_y <= to_integer(i_y(pc_GAME_BITS-1 downto 1)); --divided by two


        o_draw_WIN_txt <= pc_winner_txt(r_y - c_Y_START_BORDER)(r_x - c_X_START_BORDER) when
                            r_y >= c_Y_START_BORDER and r_y < c_Y_START_BORDER + pc_WIN_TXT_HEIGHT
                            and r_x >= c_X_START_BORDER and r_x < c_X_START_BORDER + pc_WIN_TXT_WIDTH
                            else '0';

    end RTL;