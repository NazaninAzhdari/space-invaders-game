library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.aLL;

library work;
use work.SI_pack.ALL;

entity draw_bullets is
    port (
        i_bullets       :   in      pt_bullets_pack;
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        o_draw_bullets  :   out     pt_drawing_bullets
    );
end draw_bullets;

architecture RTL of draw_bullets is
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1 :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        for i in 0 to pc_BULLET_LIMIT loop
            o_draw_bullet(i) <= '1' when i_bullets(i).Active = '1' and r_x = i_bullets(i).X and r_y = i_bullets(i).Y else '0';
        end loop;

    end RTL;