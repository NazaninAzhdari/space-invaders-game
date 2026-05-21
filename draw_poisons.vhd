library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_poisons is
    port (
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_poisons       :   in      pt_invaders_pack;
        o_draw_poisons  :   out     unsigned(pc_INV_LIMIT-1 downto 0)
    );
end draw_poisons;

architecture RTL of draw_poisons is
		signal r_x          :   integer range 0 to pc_GAME_WIDTH -1                  :=0;
    signal r_y          :   integer range 0 to pc_GAME_HEIGHT -1                 :=0;
	 
    begin
		r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);
		  
        draw_poison_gen: for i in 0 to pc_INV_LIMIT -1 generate
            o_draw_poisons(i) <= '1' when i_poisons(i).ACTIVE = '1' and r_x = i_poisons(i).X and r_y = i_poisons(i).Y else '0';
        end generate;

    end RTL;