library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity space_invaders_SM is
    port (

    );
end space_invaders_SM;

architecture RTL of space_invaders_SM is
    type t_SI_state_machine is (IDLE, GAME_RUNNING, GAME_OVER);
    signal r_SM : t_space_invaders_SM;
    begin
        process(i_clk) is
            begin
                if rising_edge(i_clk) is
                    case r_SM is
                        when IDLE =>
                            --when in the IDLE, we are in the start frame
                            --all the invaders ar in the top next to each other
                            --the tank is in the middle at the buttom
                            --nothing is moving
                            --a text "press enter to start"

                            --by pressing the enter key
                            --r_SM <= GAME_RUNNING

                        when GAME_RUNNIG =>
                            --everything start running
                            --invaders start to move from left to right, right to left with slow speed. 
                            --the tank can move from left to right and right to left

                            --inveders can shoot downside
                            --tank can shoot upside
                            --if a bullt collide with invaders, it dies
                            --if a bullet collide with tank, it will die


                        when game_OVER =>
                            --a game over text in the middle

                        when others =>
                            r_SM <= IDLE;

                        end case;
                    end if;
            end process;

            --i am using the HDMI protocol for this game => implement VGA interface. HVsync and HDMI ports
            --we are using UART to commiunicate with game, implement UART RX
            --for loading the sprites use ROM constants
            --for background use coetool
            --tilemap + sprites

    end RTL;