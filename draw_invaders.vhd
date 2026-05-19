library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_invaders is
    port (
        i_invaders      :   in      pt_invaders_pack;
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        o_draw_invaders :   out     pt_drawing_invaders
    );
end draw_invaders;

architecture RTL of drw_invaders is
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1 :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        for i in 0 to pc_INV_LIMIT-1 loop
            o_draw_invaders(i) <= pc_invader(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                    when i_invaders(i).ALIVE = '1'
                                    and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                    and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH
                                    else '0';
        end loop;


    end RTL;