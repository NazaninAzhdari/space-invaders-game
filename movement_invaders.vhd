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
		  i_kill_invader	:	in 		unsigned(pc_INV_LIMIT-1 downto 0);
        o_invaders      :   out     pt_invaders_pack
    );
end movement_invaders;

architecture RTL of movement_invaders is
    signal r_invaders   : pt_invaders_pack;  --Have to reset the game to see the invaders, not initialized.
    signal r_x_counter  : integer range 0 to pc_INVS_SPEED  :=0;
    signal r_direction  : STD_LOGIC                         :='0';
    signal w_direction  : STD_LOGIC                         :='0';
    signal r_hit_left   : STD_LOGIC                         :='0';
    signal r_hit_right  : STD_LOGIC                          :='0';

    begin
        process(i_clk) is

            begin
                if rising_edge(i_clk) then	
					if i_reset = '1' then --Since synthesis tool was trying to make a latch, i put the reset to be synchhronous
                        ---------------------------------------------------------------
                        --Resetting the x , y cordinate of invaders:
                        --the loops are written per row.
                        --the whole loops happens in one clock cycle.
                        --so after one clock cycle all the invaders has been initialized
                        -----------------------------------------------------------------
                        for i in 0 to pc_INV_ROW1_LIMIT -1 loop
                            r_invaders(i).X <= pc_X_START_INVS_BORDER + i*(pc_INV_WIDTH + pc_SPACE);
                            r_invaders(i).Y <= pc_Y_INV_ROW1;
                                    r_invaders(i).ALIVE <= '1';
                        end loop;

                        for i in pc_INV_ROW1_LIMIT to pc_INV_ROW2_LIMIT -1 loop
                            r_invaders(i).X <= pc_X_START_INVS_BORDER + (i- pc_INV_ROW1_LIMIT)*(pc_INV_WIDTH + pc_SPACE);
                            r_invaders(i).Y <= pc_Y_INV_ROW2;
                                    r_invaders(i).ALIVE <= '1';
                        end loop;

                        for i in pc_INV_ROW2_LIMIT to pc_INV_ROW3_LIMIT -1 loop
                            r_invaders(i).X <= pc_X_START_INVS_BORDER + (i- pc_INV_ROW2_LIMIT)*(pc_INV_WIDTH + pc_SPACE);
                            r_invaders(i).Y <= pc_Y_INV_ROW3;
                                    r_invaders(i).ALIVE <= '1';
                        end loop;

                        for i in pc_INV_ROW3_LIMIT to pc_INV_ROW4_LIMIT -1 loop
                            r_invaders(i).X <= pc_X_START_INVS_BORDER + (i- pc_INV_ROW3_LIMIT)*(pc_INV_WIDTH + pc_SPACE);
                            r_invaders(i).Y <= pc_Y_INV_ROW4;
                                    r_invaders(i).ALIVE <= '1';
                        end loop;

                        r_direction <= '0';
						  
				    else --if i_reset = '0'
						
                        if i_en = '1' then
                            if r_x_counter < pc_INVS_SPEED then
                                r_x_counter <= r_x_counter + 1;
                            else
                                r_x_counter <= 0;
                                if r_direction = '0' then    --zero = go left
                                    ----------------------------------------------------------------------
                                    --the x cordinates of all invaders increase by one in one clock cycle    
                                    ----------------------------------------------------------------------                
                                    for i in 0 to pc_INV_LIMIT -1 loop
                                            r_invaders(i).X <= r_invaders(i).X - 1;
                                    end loop;

                                else                         --one = go right
                                    ----------------------------------------------------------------------
                                    --the x cordinates of all invaders decrease by one in one clock cycle    
                                    ---------------------------------------------------------------------- 
                                    for i in 0 to pc_INV_LIMIT-1 loop
                                            r_invaders(i).X <= r_invaders(i).X + 1;
                                    end loop;
                                end if;
                            end if;

                            ------------------------------------------------------------------------------
                            --if hit the left border/right border, direction changes.
                            ------------------------------------------------------------------------------
                            if r_hit_left = '1' then
                                r_direction <= '1';

                            elsif r_hit_right = '1' then
                                r_direction <= '0';
                            end if;
                            
                            -------------------------------------------------------------------------------------------
                            --by falling or rising edge of the direction signal, we can determine that we have reached 
                            --the border side, so we increase the y cordinate of invaders by one
                            --------------------------------------------------------------------------------------------
                            if (r_direction = '1'  and w_direction= '0') or (r_direction = '0' and w_direction = '1') then
                                for i in 0 to pc_INV_LIMIT-1 loop
                                    r_invaders(i).Y <= r_invaders(i).Y + 1;
                                end loop;
                            end if;
                    

                            ---------------------------------------------------------------------
                            --The whole loop happens in one clock cycle.
                            --It goes through all the alive invaders. By detecting the first invader that 
                            --has been reached the left/right border, it drives r_hit_left/right high and exits the loop. 
                            --It will not check the remaining invaders after exiting the loop untll the next clock cycle.
                            --In the next clock cycle it start again and goes through all the alive invaders.
                            --Since the x cordinate of invaders move every pc_INV_SPEED clk cycles, 
                            --then the x cordinate of invedar is in border area for pc_INV_SPEED clk cycles.
                            --So the r_hit_left/right will be high for almost pc_INV_SPEED clk cycles.
                            --After moving the x cordinate from border area, r_hit_left/right becomes zero.
                            ----------------------------------------------------------------------------------------------------------      
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
									 
									 for i in 0 to pc_INV_LIMIT -1 loop
										if i_kill_invader(i) = '1' then
											r_invaders(i).ALIVE <= '0';
										end if;
										end loop;
                                        
                        end if; --i_en = '1'
                    end if; --i_reset
                end if; --rising_edge(i_clk)
            end process;


            process(i_clk) is
                begin
					 if rising_edge(i_clk) then
                    w_direction <= r_direction;
                    end if;
                end process;
					 
			o_invaders <= r_invaders;
    end RTL;


    