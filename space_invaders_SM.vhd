library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity space_invaders_SM is
    port (
        i_clk           :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_start         :   in      STD_LOGIC;
        i_right_btn     :   in      STD_LOGIC;
        i_left_btn      :   in      STD_LOGIC;
        i_bullet_btn    :   in      STD_LOGIC;
        i_x             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y             :   in      unsigned(pc_GAME_BITS-1 downto 0);
        o_x_start_SS    :   out     unsigned(pc_GAME_BITS-1 downto 0);
        o_invaders      :   out     pt_invaders_pack;
        o_bullets       :   out     pt_bullets_pack;
        o_poisons       :   out     pt_invaders_pack;
        o_run_en        :   out     STD_LOGIC
    );
end space_invaders_SM;

architecture RTL of space_invaders_SM is
    type t_SI_state_machine is (IDLE, GAME_RUNNING, WINNING, GAME_OVER);
    signal r_SM         :   t_SI_state_machine                                  :=IDLE;
    signal r_start      :   STD_LOGIC                                           :='0';
    
	 signal r_run_en      :   STD_LOGIC                                           :='0';
    signal w_x_start_SS :   unsigned(pc_GAME_BITS -1 downto 0)                   :=(others=>'0');
    signal r_x_start_SS :   integer range pc_X_START_BORDER to pc_X_END_BORDER  :=pc_X_INITIAL_SS;
    signal w_bullets    :   pt_bullets_pack;
    signal w_invaders   :   pt_invaders_pack;
    signal w_poisons  :   pt_invaders_pack;
	 
	 signal r_kill_invader : unsigned(pc_INV_LIMIT-1 downto 0):=(others=>'0');
	 signal r_kill_bullet  :  unsigned(pc_BULLET_LIMIT-1 downto 0)   :=(others=>'0');
     signal r_kill_poison : unsigned(pc_INV_LIMIT-1 downto 0):=(others=>'0');
	 
	 constant c_20bit_one : unsigned(pc_INV_LIMIT-1 downto 0) :=(others=>'1');

    begin
        process(i_clk, i_reset) is
            begin
                if rising_edge(i_clk) then
						if i_reset = '1' then
                    --game resets
                    r_SM <= IDLE;
						  r_kill_invader <= (others=>'0');
						  r_kill_bullet <= (others=>'0');
                    r_kill_poison <= (others=>'0');
						  
						  
						else --i_reset = '0'
					 
                    case r_SM is
                        when IDLE =>
                            --when in the IDLE, we are in the start frame
                            --all the invaders ar in the top next to each other
                            --the tank is in the middle at the buttom
                            --nothing is moving
                            --a text "press enter to start"

                            --by pressing the enter key
                            --r_SM <= GAME_RUNNING
                            if i_start = '0' and r_start = '1' then
                                r_SM <= GAME_RUNNING;
                            end if;

                        when GAME_RUNNING =>
                            --everything start running
                            --invaders start to move from left to right, right to left with slow speed. 
                            --the tank can move from left to right and right to left

                            --inveders can shoot downside
                            --tank can shoot upside
                            --if a bullt collide with invaders, it dies
                            --if a bullet collide with tank, it will die
                            for i in 0 to pc_BULLET_LIMIT-1 loop
                                if w_bullets(i).Active = '1' then
                                    for j in 0 to pc_INV_LIMIT-1 loop
                                        if w_invaders(j).ACTIVE = '1' then
                                            if w_bullets(i).X >= w_invaders(j).X and w_bullets(i).X < w_invaders(j).X + pc_INV_WIDTH 
                                            and w_bullets(i).Y >= w_invaders(j).Y and w_bullets(i).Y < w_invaders(j).Y + pc_INV_HEIGHT then
                                                r_kill_bullet(i) <= '1';
																r_kill_invader(j) <= '1';
                                            end if;
                                        end if;
                                    end loop;
											else
												r_kill_bullet(i) <= '0';
                                end if;
                            end loop;

                            for i in 0 to pc_BULLET_LIMIT-1 loop
                                if w_poisons(i).Active = '1' then
                                    if w_poisons(i).X >= r_x_start_SS and w_poisons(i).X < r_X_start_SS + pc_SS_WIDTH
                                        and w_poisons(i).Y >= pc_Y_start_SS + 2 and w_poisons(i).Y <= pc_Y_END_SS then
                                            r_kill_poison(i) <= '1';
                                            --r_kill_SS <= '1';
														  r_SM <= GAME_OVER;
                                    end if;
                                else
                                    r_kill_poison(i) <= '0';    
                                end if;

                             end loop;
											

									 
                            for i in 0 to pc_INV_LIMIT -1 loop
                                if w_invaders(i).Y + pc_INV_HEIGHT = 119 then
                                        r_SM <= GAME_OVER;
                                    end if;
                            end loop;

                            if r_kill_invader = c_20bit_one then
                                r_SM <= WINNING;
                            end if;
								
						when WINNING =>
										--wiinng the game

                        when game_OVER =>
                            --a game over text in the middle

                        when others =>
                            r_SM <= IDLE;

                        end case;
                    end if;
						  end if;
            end process;

            process(i_clk) is
                begin
                    if rising_edge(i_clk) then
                        r_start <= i_start;
                    end if;
                end process;

            r_run_en <= '1' when r_SM = GAME_RUNNING else '0';
            o_run_en <= r_run_en;

            --i am using the HDMI protocol for this game => implement VGA interface. HVsync and HDMI ports
            --we are using UART to commiunicate with game, implement UART RX
            --for loading the sprites use ROM constants
            --for background use coetool
            --tilemap + sprites

        -----------------------------------------
        --movement of space_sheep
        -----------------------------------------
        space_sheep_movement: entity work.movement_spaceSheep
        port map (
            i_clk=> i_clk, --25MHZ
            i_reset=> i_reset,
            i_en=> r_run_en,
            i_right_button=> i_right_btn,
            i_left_button=> i_left_btn,
            i_x => i_x,
            i_y=> i_y,
            o_x_start_SS => w_x_start_SS
        );
        r_x_start_SS <= to_integer(w_x_start_SS);
        o_x_start_SS <= w_x_start_SS;
        
        -----------------------------------------
        --movement of bullets
        -----------------------------------------
        bullet_movement: entity work.movement_bullet
        port map(
            i_clk => i_clk,  --25MHz
            i_reset => i_reset,
            i_en => r_run_en,
            i_x_ss => w_x_start_ss,
            i_bullet_button => i_bullet_btn,
				i_kill_bullet => r_kill_bullet,
            o_bullets => w_bullets
        );
        o_bullets <= w_bullets;

        -----------------------------------------
        --movement of invaders
        -----------------------------------------
        invaders_movement: entity work.movement_invaders
        port map(
            i_clk => i_clk,
            i_reset => i_reset,
            i_en => r_run_en,
				i_kill_invader => r_kill_invader,
            o_invaders => w_invaders
        );
        o_invaders <= w_invaders;

        --------------------------------------------
        --movement of poisons
        --------------------------------------------
        poisons_movement: entity work.movement_poison
        port map(
            i_clk => i_clk,
            i_reset => i_reset,
            i_en => r_run_en,
            i_invaders => w_invaders,
            i_kill_poison => r_kill_poison,
            o_poisons => w_poisons
        );
            o_poisons <= w_poisons;


    end RTL;