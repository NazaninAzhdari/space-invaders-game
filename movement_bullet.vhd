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
        i_x_ss          :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_bullet_button :   in      STD_LOGIC;
		  i_kill_bullet	:	 in 		unsigned(pc_BULLET_LIMIT -1 downto 0);
        o_bullets       :   out     pt_bullets_pack
    );
end movement_bullet;

architecture RTL of movement_bullet is
    signal r_bullets        :  pt_bullets_pack   :=(others=> (
                                                    X => pc_X_START_BULLET,
                                                    Y => pc_Y_START_BULLET,
                                                    ACTIVE => '0'));
    
    signal r_x_SS           :   integer range 0 to pc_GAME_WIDTH -1 :=0;
    signal r_counter        :   integer range 0 to pc_BULLET_SPEED  :=0;
	signal r_bullet_button  : STD_LOGIC  :='0';

    begin
        r_x_SS <= to_integer(i_x_SS);

        process(i_clk, i_reset) is
            begin
                if i_reset = '1' then
                    -----------------------------------------------------------------
                    --The whole loop happens in oly one clock cycle but in sequence.
                    --All the Bullets get initialized in one clock cycle.
                    ----------------------------------------------------------------
                    for i in 0 to pc_BULLET_LIMIT-1 loop
                        r_bullets(i).X <= pc_X_START_BULLET;
                        r_bullets(i).Y <= pc_Y_START_BULLET;
                        r_bullets(i).ACTIVE <= '0';
                    end loop;
                    r_counter <= 0;

                elsif rising_edge(i_clk) then
                    if i_en = '1' then
                        ---------------------------------------------------------------------------------------------------------------
                        --if button pressed and released, the whole loop starts and it happens in one clock cycle but in sequence
                        --when the first inactive bullet gets activated, the loop ends. BCS of exit statement.
                        --so only one bullet will be shooted.
                        --if all the bullets are active, nothing will be shooted.
                        --NB! if instead of falling edge of button, i only check i_bullet_btn = '1' the logic will not work as expected
                        --Reason: BCS if you press the button, the button will be high for more than one clock cycles
                        --since each bullet will be shooted at oone clock cycle.
                        --so all the bullets will be shooted by pressing the button.
                        --since they have been shooted by one clock cycle apart, their x and y would be the same.
                        --so you only see one bullet. but its actully all the bullets that they are overlapping.
                        ----------------------------------------------------------------------------------------------------------------
                        if i_bullet_button = '0' and r_bullet_button = '1' then
                            for i in 0 to pc_BULLET_LIMIT-1 loop
                                if r_bullets(i).ACTIVE = '0' then
                                    r_bullets(i).ACTIVE <= '1';
                                    r_bullets(i).X <= r_x_SS + (pc_SS_WIDTH/2);
                                    r_bullets(i).Y <= pc_Y_START_BULLET;
                                    exit;
                                end if;
                            end loop;
                        end if;

                        ---------------------------------------------------------
                        --with r_counter we adjust the speed of the bullet
                        ---------------------------------------------------------
                        if r_counter < pc_BULLET_SPEED then
                            r_counter <= r_counter + 1;
                        else
                            r_counter <= 0;
                            ------------------------------------------------------------------------
                            --the whole loop happens in one clock cycle.
                            --in the clock cycle that r_counter = pc_BULLET_SPEED, all the active bullets will move upward by one.
                            --in the next clock cycle r_counter becomes zero. 
                            --r_counter increase by one in each clock cycle and 
                            --when it reaches to pc_BULLET_SPEED, the whole loop happens again
                            -------------------------------------------------------------------------
                            for i in 0 to pc_BULLET_LIMIT-1 loop
                                if r_bullets(i).ACTIVE = '1' then
                                    if r_bullets(i).Y > 0 then
                                        r_bullets(i).Y <= r_bullets(i).Y - 1;
                                        
                                    else --if bullet reach the top of the screen, the bullet becomes inactive and locate in initial state.
                                        r_bullets(i).Y <= pc_Y_START_BULLET;
                                        r_bullets(i).ACTIVE <= '0';
                                    end if;
                                end if;
                            end loop;
									 
									 
									 for i in 0 to pc_BULLET_LIMIT -1 loop
										if i_kill_bullet(i) = '1' then
											r_bullets(i).Y <= pc_Y_START_BULLET;
											r_bullets(i).ACTIVE <= '0';
										end if;
										end loop;
										
                        end if;

                    end if;
                end if;
            end process;

            process(i_clk) is
                begin
                    if rising_edge(i_clk) then
                        r_bullet_button <= i_bullet_button;
                    end if;
                end process;

            o_bullets <= r_bullets;

    end RTL;