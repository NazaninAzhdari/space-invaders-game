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
    signal r_invaders   : pt_invaders_pack                  :=pc_INITIAL_INVADERS; 
    signal r_x_counter  : integer range 0 to pc_INVS_SPEED  :=0;
    signal r_direction  : STD_LOGIC                         :='0';
    signal w_direction  : STD_LOGIC                         :='0';
    signal r_hit_left   : STD_LOGIC                         :='0';
    signal r_hit_right  : STD_LOGIC                         :='0';

    begin
        process(i_clk) is

            begin
                if rising_edge(i_clk) then
					w_direction <= r_direction; 
					if i_reset = '1' then       --First, Reset logic was asynchronous. Synthesis tool was trying to make a latch, 
                                                --I put the reset to be synchhronous and problem resolved.
                        r_invaders <= pc_INITIAL_INVADERS;
                        r_direction <= '0';
						  
				    else --if i_reset = '0'
						
                        if i_en = '1' then
                            if r_x_counter < pc_INVS_SPEED then
                                r_x_counter <= r_x_counter + 1;
                            else
                                r_x_counter <= 0;
                                if r_direction = '0' then    --zero = go left
                                    ----------------------------------------------------------------------
                                    --The x cordinates of all invaders increases by one in one clock cycle    
                                    ----------------------------------------------------------------------                
                                    for i in 0 to pc_INV_LIMIT -1 loop
                                            r_invaders(i).X <= r_invaders(i).X - 1;
                                    end loop;

                                else                         --one = go right
                                    ----------------------------------------------------------------------
                                    --The x cordinates of all invaders decreases by one in one clock cycle    
                                    ---------------------------------------------------------------------- 
                                    for i in 0 to pc_INV_LIMIT-1 loop
                                            r_invaders(i).X <= r_invaders(i).X + 1;
                                    end loop;
                                end if;
                            end if;

                            ------------------------------------------------------------------------------
                            --If hit the left border/right border, direction changes.
                            ------------------------------------------------------------------------------
                            if r_hit_left = '1' then
                                r_direction <= '1';

                            elsif r_hit_right = '1' then
                                r_direction <= '0';
                            end if;
                            
                            -------------------------------------------------------------------------------------------
                            --By falling or rising edge of the direction signal, we can determine that we have reached 
                            --the border, So we increase the y cordinate of invaders by one.
                            -------------------------------------------------------------------------------------------
                            if (r_direction = '1'  and w_direction= '0') or (r_direction = '0' and w_direction = '1') then
                                for i in 0 to pc_INV_LIMIT-1 loop
                                    r_invaders(i).Y <= r_invaders(i).Y + 1;
                                end loop;
                            end if;

                            --------------------------------------------------------------------------------------------
                            --The whole loop happens in one clock cycle.
                            --The loop goes through all the ACTIVE invaders. By detecting the first invader that 
                            --has been reached the left/right border, it drives r_hit_left/right high and exits the loop. 
                            --It will not check the remaining invaders after exiting the loop until the next clock cycle.
                            --In the next clock cycle it start again and goes through all the ACTIVE invaders.
                            --Since the x cordinate of invaders move every pc_INV_SPEED clk cycles, 
                            --then the x cordinate of invedar is in border area for pc_INV_SPEED clk cycles.
                            --So the r_hit_left/right will be high for almost pc_INV_SPEED clk cycles.
                            --After moving the x cordinate from border area, r_hit_left/right becomes zero.
                            ---------------------------------------------------------------------------------------------
                            for i in 0 to pc_INV_LIMIT-1 loop
                                if r_invaders(i).ACTIVE = '1' then
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
                                        
                        end if; --i_en = '1'
					
                    ------------------------------------------------------------------
                    --If a bullet collides with an invader, the invader will be killed
                    --and i_kill_invader goes high, so we put it to be inactive.
                    ------------------------------------------------------------------
                    for i in 0 to pc_INV_LIMIT -1 loop
                        if i_kill_invader(i) = '1' then
                            r_invaders(i).ACTIVE <= '0';
                        end if;
                    end loop;
										
                    end if; --i_reset= '1' or else
                end if; --rising_edge(i_clk)
            end process;

			o_invaders <= r_invaders;
    end RTL;


    