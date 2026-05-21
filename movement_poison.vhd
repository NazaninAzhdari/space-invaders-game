library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity movement_poison is
    port (
        i_clk       :   in      STD_LOGIC;
        i_reset     :   in      STD_LOGIC;
        i_en        :   in      STD_LOGIC;
        i_invaders  :   in      pt_invaders_pack;
        i_kill_poison : in     unsigned(pc_INV_LIMIT-1 downto 0);
        o_poisons :  out  pt_invaders_pack

    );
end movement_poison;

architecture RTL of movement_poison is
    signal w_lfsr   :   unsigned(4 downto 0)    :=(others=>'0');
    signal r_poison_ID : integer range 0 to pc_INV_LIMIT -1 :=0;
    signal r_poisons  :  pt_invaders_pack;
    signal r_speed_counter : integer range 0 to pc_POISON_SPEED :=0;
    signal r_time_counter : integer range 0 to pc_TIME_BETWEEN_POISONS :=0;
    signal r_poison_en : STD_LOGIC :='0';

    begin

        ---------------------------------------------------------
        --Using LFSR5 to generate random numbers between 0 to 31
        ---------------------------------------------------------
        gen_random_num: entity work.LFSR5
        port map(
            i_clk=> i_clk,
            o_lfsr=> w_lfsr
        );

        ----------------------------------------------------------------------------------------------------------------------
        --We do have 20 Invaders and each of these invaders has one poison that they can shoot toward the space-sheep.
        --So in total we have 20 poisons.
        --The poisons are shooted randomly toward the space-sheep. To determine that which poison is going to shooted, we use 
        --the poison_ID signal. the poison_ID will be determined based on the state of LFSR.
        --Our LFSR generate psudo-random numbers from 0 to 31, but we only have 20 poisons.
        --So for the LFSR states bigger than 20, we subtract them by 20 to get a value in the range of invaders(0 to 19).
        ----------------------------------------------------------------------------------------------------------------------
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if to_integer(w_lfsr) <= pc_INV_LIMIT -1 then
                        r_poison_ID <= to_integer(w_lfsr);
                    else
                        r_poison_ID <= to_integer(w_lfsr) - 20;
                    end if;    
                end if;
            end process;


        process(i_clk) is
            begin
                if rising_edge(i_clk) then
					 if i_reset = '1' then
                    ---------------------------------------------------------
                    --if we reset the game all the poisons becomes inactive 
                    --and they will be placed in the locartion of invaders.
                    ---------------------------------------------------------
                    for i in 0 to pc_INV_LIMIT -1 loop
                        r_poisons(i).ACTIVE <= '0';
                        r_poisons(i).X <= i_invaders(i).X;
                        r_poisons(i).Y <= i_invaders(i).Y;
                    end loop;
						  
						  
					 else --if i_reset = '0'
					 
                    if i_en = '1' then
                        --------------------------------------------------------------------------------
                        --**r_poison_en is high only for one clock cycle.**
                        --if poison logic gets enabled, the invader is ALive and its poison is inactive.
                        --then we can shoot its poison.(poison becomes active)
                        ---------------------------------------------------------------------------------
                        if r_poison_en = '1' then
                            for i in 0 to pc_INV_LIMIT -1 loop
                                if r_poisons(i).ACTIVE = '0' and i_invaders(i).ACTIVE = '1' then
                                    if i = r_poison_ID then
                                        r_poisons(i).ACTIVE <= '1';
                                        r_poisons(i).X <= i_invaders(i).X;
                                        r_poisons(i).Y <= i_invaders(i).Y;
                                    end if;
                                end if;
                        end loop;
								end if;


                        -------------------------------------------------------------------
                        --all the Active poisons move downward every pc_POISON_SPEED times
                        --if they reach the end of screen, they becomes inactive
                        -------------------------------------------------------------------
                        if r_speed_counter < pc_POISON_SPEED then
                            r_speed_counter <= r_speed_counter + 1;
                        else
                            r_speed_counter <= 0;

                            for i in 0 to pc_INV_LIMIT -1 loop
                                if r_poisons(i).ACTIVE = '1' then
                                    if r_poisons(i).Y < 119 then
                                        r_poisons(i).Y <= r_poisons(i).Y + 1;
                                    else
                                        r_poisons(i).ACTIVE <= '0';
                                    end if;
                                end if;
                            end loop;

                        end if;

                        -------------------------------------------------------------------
                        --r_poison_enable becomes high for only one clock cycles
                        --its low for the pc_TIME_BETWEEN_POISONS
                        -------------------------------------------------------------------
                        if r_time_counter < pc_TIME_BETWEEN_POISONS then
                            r_time_counter <= r_time_counter + 1;
                            r_poison_en <= '0';
                        else
                            r_time_counter <=0;
                            r_poison_en <= '1';
                        end if;

                        -------------------------------------------------------------------
                        --if poison collide with space-sheep, r_kill_poison goes high
                        --thus the poison becomes inactive.
                        -------------------------------------------------------------------
                        for i in 0 to pc_INV_LIMIT -1 loop
                            if i_kill_poison(i) = '1' then
                                r_poisons(i).ACTIVE <= '0';
                            end if;
                        end loop;


                    end if;
                end if;
					 end if;
            end process;
            
            o_poisons <= r_poisons;


    end RTL;