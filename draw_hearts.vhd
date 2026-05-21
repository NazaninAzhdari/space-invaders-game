library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_hearts is
    port (
        i_x         :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y         :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_lives     :   in      integer;
        o_draw_hearts : out     STD_LOGIC
    );
end draw_hearts;

architecture RTL of draw_hearts is
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1 :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;

    signal r_draw_H1, r_draw_H2 , r_draw_H3  :  STD_LOGIC  :='0';

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);


        r_draw_H1 <= pc_heart(r_y - pc_Y_START_HEART)(r_x - pc_X_START_H1) when i_lives >= 1
                            and r_y >= pc_Y_START_HEART and r_y < pc_Y_END_HEART
                            and r_x >= pc_X_START_H1 and r_x < pc_X_END_H1
                            else '0';

        r_draw_H2 <= pc_heart(r_y - pc_Y_START_HEART)(r_x - pc_X_START_H2) when i_lives >= 2
                            and r_y >= pc_Y_START_HEART and r_y < pc_Y_END_HEART
                            and r_x >= pc_X_START_H2 and r_x < pc_X_END_H2
                            else '0';

        r_draw_H3 <= pc_heart(r_y - pc_Y_START_HEART)(r_x - pc_X_START_H3) when i_lives >= 3
                            and r_y >= pc_Y_START_HEART and r_y < pc_Y_END_HEART
                            and r_x >= pc_X_START_H3 and r_x < pc_X_END_H3
                            else '0';

        o_draw_hearts <= r_draw_H1 or r_draw_H2 or r_draw_H3;

    end RTL;