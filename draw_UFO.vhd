library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_UFO is
    port (
        i_clk           :   in      STD_LOGIC;
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_x_start_ufo   :   in      signed(pc_GAME_BITS downto 0);
        i_ufo_active    :   in      STD_LOGIC;
        o_draw_UFO      :   out     STD_LOGIC    
    );
end draw_UFO;

architecture RTL of draw_UFO is
    signal r_x           :   integer range 0 to pc_GAME_WIDTH -1  :=0;
    signal r_y           :   integer range 0 to pc_GAME_HEIGHT -1 :=0;
    signal r_x_start_ufo :   integer range -255 to 255            :=-255;
    signal r_ufo_active  :   STD_LOGIC                            :='0';
    signal r_counter     :   integer range 0 to pc_BURST_SPEED    :=0;
    signal r_burst_ufo   :   STD_LOGIC                            :='0';

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);
        r_x_start_ufo <= to_integer(i_x_start_ufo);

        ------------------------------------------------------------
        --Drawing UFO at spicific location
        --if UFO collide with bullet, draw burst instead of UFO.
        ------------------------------------------------------------
        o_draw_UFO <= pc_UFO(r_y - pc_Y_START_UFO)(r_x - r_x_start_ufo) 
                                    when i_UFO_active = '1'
                                    and r_y >= pc_Y_START_UFO and r_y < pc_Y_END_UFO
                                    and r_x >= r_x_start_ufo and r_x < r_x_start_UFO + pc_UFO_WIDTH else
                    pc_burst(r_y - pc_Y_START_UFO)(r_x - r_x_start_ufo)
                                    when r_burst_ufo = '1'
                                    and r_y >= pc_Y_START_UFO and r_y < pc_Y_END_UFO
                                    and r_x >= r_x_start_ufo and r_x < r_x_start_UFO + pc_UFO_WIDTH
                                    else '0';

        ---------------------------------------------------------------------------------
        --In the falling edge of UFO-Active signal, we can determine that UFO has killed.
        --So we drive the burst signal to be high.
        --The burst signal becomes low after pc_BURST_SPEED clock cycle.
        ----------------------------------------------------------------------------------
        process(i_clk) is 
            begin
                if rising_edge(i_clk) then
                    r_ufo_active <= i_ufo_active;

                    if i_ufo_active = '0' and r_ufo_active = '1' then
                        r_burst_ufo <= '1';
                    end if;

                    if r_counter < pc_BURST_SPEED then
                        r_counter <= r_counter + 1;
                    else
                        r_counter <= 0;
                        r_burst_ufo <= '0';
                    end if;

                end if;
            end process;

    
    end RTL;