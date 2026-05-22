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
        o_draw_bullets  :   out     unsigned(pc_BULLET_LIMIT -1 downto 0)
    );
end draw_bullets;

architecture RTL of draw_bullets is
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1  :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        -----------------------------------------------------------------------------------------------------------------------------
        --we cannot use for loop inside the concurrent environment, the for loops are allowed inside the process or generate blocks.
        --since I want myfor loop to happen concurrently without depending on clock. i will put it inside a generate block.
        -----------------------------------------------------------------------------------------------------------------------------
        bullet_gen: for i in 0 to pc_BULLET_LIMIT -1 generate
		  begin
            o_draw_bullets(i) <= '1' when i_bullets(i).Active = '1' and r_x = i_bullets(i).X and r_y = i_bullets(i).Y else '0';
        end generate;

    end RTL;