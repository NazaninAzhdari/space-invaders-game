library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity movement_invaders is
    port (
        i_clk           :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_en            :   in      STD_LOGIC;
        i_x             :   in      unsigned(pc_GAME_BITS -1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        o_invaders      :   out     pt_invaders_pack
    );
end movement_invaders;

architecture RTL of movement_invaders is
    signal r_x              :   integer range 0 to pc_GAME_WIDTH -1   :=0;
    signal r_y              :   integer range 0 to pc_GAME_HEIGHT -1  :=0;

    signal r_invaders_column1   : pt_invaders_pack;  --you have to reset the game to see the invaders, not initialized
    signal r_invaders_column2   : pt_invaders_pack;
    signal r_invaders_column3   : pt_invaders_pack;
    signal r_invaders_column4   : pt_invaders_pack;
    signal r_invaders_column5   : pt_invaders_pack;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        process(i_clk) is
            begin
                if i_reset = '1' then
                    --resetting the x cordinate of invaders
                    for i in 0 to pc_INV_IMIT loop
                        if i >= 0 and i< pc_INV_ROW1_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + i*pc_INV_WIDTH;
                        elsif i>= pc_INV_ROW1 and i <pc_INV_ROW2_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + (i- pc_INV_ROW1)*pc_INV_WIDTH;
                        elsif i>= pc_INV_ROW2 and i <pc_INV_ROW3_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + (i- pc_INV_ROW2)*pc_INV_WIDTH;
                        elsif i>= pc_INV_ROW3 and i <pc_INV_ROW4_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + (i- pc_INV_ROW3)*pc_INV_WIDTH;
                        end if;
                    end loop;

                    --resetting y cordinate of invaders
                    for i in 0 to pc_INV_LIMIT then
                        if i >= 0 and i< pc_INV_ROW1 then
                            r_invaders(i).Y <= pc_Y_INV_ROW1;
                        elsif i>= pc_INV_ROW1 and i <pc_INV_ROW2 then
                            r_invaders(i).Y <= pc_Y_INV_ROW2;
                        elsif i>= pc_INV_ROW2 and i <pc_INV_ROW3 then
                            r_invaders(i).Y <= pc_Y_INV_ROW3;
                        elsif i>= pc_INV_ROW3 and i <pc_INV_ROW4 then
                            r_invaders(i).Y <= pc_Y_INV_ROW4;
                        end if;
                    end loop;

                    --resetting the aliveness
                    for i in 0 to pc_INV_LIMIT then
                        r_invaders(i).ALIVE <= '1';
                    end loop;

                    --resetting the conter
                    r_counter <= 0;

                elsif rising_edge(i_clk) then
                    if i_en = '1' then
                        for i in 0 to pc_INV_LIMIT loop

                            if r_counter < pc_INVS_SPEED then
                                r_counter <= r_counter + 1;
                            else
                                r_counter <= 0;
                                if r_invaders(i).X < r_x_inv_previous(i) then
                                    if r_invaders(i).X > r_X_START_BORDER - r_invaders(i).X then
                                        r_invaders(i).X <= r_invaders(i).X -1;
                                    else
                                        r_invaders(i).X <= r_invaders(i).X +1;
                                        r_invaders(i).Y  <= r_invaders(i).Y + 1;
                                    end if;
                                
                                elsif r_invaders(i).X > r_x_inv_previous(i) then
                                    if r_invaders(i).X < pc_X_END_BORDER then
                                        r_invaders(i).X <= r_invaders(i).X + 1;
                                    else
                                        r_invaders(i).X <= r_invaders(i).X -1;
                                        r_invaders(i).Y  <= r_invaders(i).Y  + 1;
                                    end if;
                                end if;

                                --this will never happen, but in case
                                if r_invaders(i).Y > pc_Y_END_BORDER then
                                    r_invaders(i).Y <= pc_Y_START_BORDER;----
                                end if;

                        end if;
                        


            end process;

    end RTL;

    if r_counter < pc_INVS_SPEED then
                                r_counter <= r_counter + 1;
                            else
                                r_counter <= 0;
                                if r_x_inv < r_x_inv_previous then
                                    if r_x_inv > pc_X_START_BORDER then
                                        r_x_inv <= r_x_inv -1;
                                    else
                                        r_x_inv <= r_x_inv +1;
                                        r_y_inv <= r_y_inv+ 1;
                                    end if;
                                
                                elsif r_x_inv > r_x_previous then
                                    if r_x_inv < pc_X_END_BORDER then
                                        r_x_inv <= r_x_inv + 1;
                                    else
                                        r_x_inv <= r_x_inv -1;
                                        r_y_inv <= r_y_inv + 1;
                                    end if;
                                end if;

                                --this will never happen, but in case
                                if r_y_inv > pc_Y_END_BORDER then
                                    r_y_inv <= pc_Y_START_BORDER;
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



                        f i_go_right = '1' then
                for i in 0 to pc_INV_LIMIT loop
                    r_invaders(i).X <= r_invaders(i).X + 1;
                end loop;
            
            elsif i_go_left = '1' then
                for i in 0 to pc_INV_LIMIT loop
                    r_invaders(i).X <= r_invaders(i).X - 1;
                end loop;
            end if;


            for i in 0 to pc_INV_LIMIT loop
                        if i >= 0 and i< pc_INV_ROW1_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + i*pc_INV_WIDTH;
                        elsif i>= pc_INV_ROW1 and i <pc_INV_ROW2_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + (i- pc_INV_ROW1)*pc_INV_WIDTH;
                        elsif i>= pc_INV_ROW2 and i <pc_INV_ROW3_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + (i- pc_INV_ROW2)*pc_INV_WIDTH;
                        elsif i>= pc_INV_ROW3 and i <pc_INV_ROW4_LIMIT then
                            r_invaders(i).X <= pc_X_START_BORDER + (i- pc_INV_ROW3)*pc_INV_WIDTH;
                        end if;
                    end loop;

                    --resetting y cordinate of invaders
                    for i in 0 to pc_INV_LIMIT then
                        if i >= 0 and i< pc_INV_ROW1 then
                            r_invaders(i).Y <= pc_Y_INV_ROW1;
                        elsif i>= pc_INV_ROW1 and i <pc_INV_ROW2 then
                            r_invaders(i).Y <= pc_Y_INV_ROW2;
                        elsif i>= pc_INV_ROW2 and i <pc_INV_ROW3 then
                            r_invaders(i).Y <= pc_Y_INV_ROW3;
                        elsif i>= pc_INV_ROW3 and i <pc_INV_ROW4 then
                            r_invaders(i).Y <= pc_Y_INV_ROW4;
                        end if;
                    end loop;

                    --in each clock cycle the hit variables becomes zero
                        --then in the loop it checks all the invaders position in only one clock cycle. and if only one of the invaders hit the right or left
                        --the variable gets updated.
                        --in the next clock cycle variables becomes zero.
                        --if invaders dont hit , they stay zero.
                        r_hit_left := '0';
                        r_hit_right := '0';
                        --all the iteration of this for loop happens in one clock cycle, they happens sequentially, but only in one clock cycle
                        for i in 0 to pc_INV_LIMIT-1 loop
                            if r_invaders(i).ALIVE = '1' then
                                if r_invaders(i).X  < pc_X_START_BORDER - 1 then
                                    r_hit_left := '1';
                                    
                                elsif r_invaders(i).X + pc_INV_WIDTH = pc_X_END_BORDER then
                                    r_hit_right := '1';
                                    
                                end if;
                            end if;
                        end loop;



                        if r_y_counter < pc_INVS_SPEED then
									 r_y_counter <= r_y_counter + 1;
								else
									 r_y_counter <= 0;
										for i in 0 to pc_INV_LIMIT-1 loop
											 if r_invaders(i).ALIVE = '1' then
												  if r_invaders(i).X  <= pc_X_START_BORDER then
														r_hit_left <= '1';
														exit;
												  elsif r_invaders(i).X + pc_INV_WIDTH >= pc_X_END_BORDER then
														r_hit_right <= '1';
														exit;
													else
														r_hit_left <= '0';
														r_hit_right <= '0';
												  end if;
											 end if;
										end loop;
									end if;
