library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity movement_spaceSheep is
    port (
        i_clk        :   in      STD_LOGIC;
        i_reset      :   in      STD_LOGIC;
        i_en         :   in      STD_LOGIC;
        i_x          :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y          :   in      unsigned(pc_GAME_BITS -1 downto 0);
        o_x_start_SS :   out     unsigned(pc_GAME_BITS -1 downto 0);
    );
end movement_spaceSheep;

architecture RTL of movement_spaceSheep is
    signal r_x              :   integer range 0 to pc_GAME_WIDTH -1                 :=0;
    signal r_y              :   integer range 0 to pc_GAME_HEIGHT -1                :=0;
    signal r_left_counter   :   integer range 0 to pc_SS_SPEED                      :=0;
    signal r_right_counter  :   integer range 0 to pc_SS_SPEED                      :=0;
    signal r_x_start_SS     :   integer range pc_X_START_BORDER to pc_X_END_BORDER  :=pc_X_MIDDLE_BORDER;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        process(i_clk) is
            begin
                if i_reset = '1' then 
                    r_x_start_SS <= pc_X_MIDDLE_BORDER;
                    r_right_counter <= 0;
                    r_left_counter <= 0;

                elsif rising_edge(i_clk) then
                    if i_en = '1' then
                        if i_right_button = '1' then
                            if r_right_counter < pc_SS_SPEED then
                                r_right_counter <= r_right_counter + 1;
                            else
                                r_right_counter <= 0;
                                if r_x_start_SS < pc_X_END_BORDER then
                                    r_x_start_SS <= r_x_start_SS + 1;
                                end if;
                            end if;
                            r_left_counter <= 0;


                        elsif i_left_button = '1' then
                            if r_left_counter < pc_SS_SPEED then
                                r_left_counter <= r_left_counter + 1;
                            else
                                r_left_counter <= 0;
                                if r_x_start_SS > pc_X_START_BORDER then
                                    r_x_start_SS <= r_x_start_SS - 1;
                                end if;
                            end if;
                            r_right_counter <= 0;

                        else
                            r_left_counter <= 0;
                            r_right_counter <= 0;
                            
                        end if;
                    end if;
                end if;
            end process;

            o_x_start_SS <= to_unsigned(r_x_start_SS, o_x_start_SS'length);

    end RTL;