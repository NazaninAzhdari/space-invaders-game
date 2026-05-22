library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity movement_UFO is
    port (
        i_clk           :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_en            :   in      STD_LOGIC;
        o_x_start_UFO   :   out     signed(pc_GAME_BITS downto 0)  --one bit more , bcs signed
    );
end movement_UFO;

architecture RTL of movement_UFO is
    signal r_x_start_UFO : integer range -255 to 255    :=-255;
    signal r_counter : integer range 0 to pc_UFO_SPEED  :=0;

    begin
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if i_reset = '1' then
                        r_x_start_ufo <= -255;

                    else
                        if i_en = '1' then

                            if r_counter < pc_UFO_SPEED then
                                r_counter <= r_counter + 1;
                            else
                                r_counter <= 0;
                                r_x_start_UFO <= r_x_start_ufo + 1;
                            end if;

                            if r_x_start_UFO >= 255 then
                                r_x_start_UFO <= -255;
                            end if;

                        end if;
                    end if;
                end if;
            end process;

            o_x_start_ufo <= to_signed(r_x_start_ufo, o_x_start_ufo'length);

    end RTL;