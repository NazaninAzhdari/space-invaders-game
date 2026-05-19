library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity movement_bullet is
    port (
        i_clk           :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_en            :   in      STD_LOGIC;
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_x_ss          :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_bullet_button :   in      STD_LOGIC;
        o_bullets       :   out     pt_bullet_pack
    );
end movement_bullet;

architecture RTL of movement_bullet is
    signal r_bullets        :  t_bullet_pack   :=(others=>
                                                    X <= pc_X_START_BULLET;
                                                    Y <= pc_Y_START_BULLET;
                                                    ACTIVE <= '0');
    
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1 :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;
    signal r_x_SS :   integer range 0 to pc_GAME_WIDTH -1 :=0;
    signal r_counter : integer range 0 to pc_BULLET_SPEED  :=0;


    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);
        r_x_SS <= to_integer(i_x_SS);

        process(i_clk) is
            begin
                if i_reset = '1' then
                    for i in 0 to pc_BULLET_LIMIT loop
                        r_bullets(i).X <= pc_X_START_BULLET;
                        r_bullets(i).Y <= pc_Y_START_BULLET;
                        r_bullets(i).ACTIVE <= '0';
                    end loop;
                    r_counter <= 0;

                elsif rising_edge(i_clk) then
                    if i_en = '1' then

                        if i_bullet_button = '1' then
                            for i in 0 to pc_BULLET_LIMIT loop
                                if r_bullets(i).ACTIVE = '0' then
                                    r_bullets(i).ACTIVE <= '1';
                                    r_bullets(i).X <= r_x_SS + (pc_SS_WIDTH/2) - 1;
                                    exit;
                                end if;
                            end loop;
                        end if;

                        for i in 0 to pc_BULLET_LIMIT loop
                            if r_bullets(i).ACTIVE = '1' then
                                if r_bullets(i).Y /=0 then
                                    if r_counter < pc_BULLET_SPEED then
                                        r_counter <= r_counter + 1;
                                    else
                                        r_counter <= 0;
                                        r_bullets(i)(Y) <= r_bllets(i)(Y) - 1;
                                    end if;
                                else
                                    r_bullets(i).Y <= pc_Y_START_BULLET;
                                    r_bullets(i).ACTIVE <= '0';
                                end if;
                            end if;
                        end loop;

                    end if;
                end if;
            end process;

            o_bullets <= r_bullets;

    end RTL;