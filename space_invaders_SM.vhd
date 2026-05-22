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
        o_x_start_ufo   :   out     signed(pc_GAME_BITS downto 0);
        o_invaders      :   out     pt_invaders_pack;
        o_bullets       :   out     pt_bullets_pack;
        o_poisons       :   out     pt_invaders_pack;
        o_lives         :   out     integer;
        o_ufo_active    :   out     STD_LOGIC;
        o_start_en      :   out     STD_LOGIC;
        o_run_en        :   out     STD_LOGIC;
        o_loose_live_en :   out     STD_LOGIC;
        o_win_en        :   out     STD_LOGIC;
        o_end_en        :   out     STD_LOGIC
    );
end space_invaders_SM;

architecture RTL of space_invaders_SM is
    --State Machine
    type t_SI_state_machine is (IDLE, GAME_RUNNING, LOOSE_LIVE, WINNING, GAME_OVER);
    signal r_SM         :   t_SI_state_machine     :=IDLE;

    --Signals related to Objects of the game
    signal w_x_start_SS :   unsigned(pc_GAME_BITS -1 downto 0)                  :=(others=>'0');
    signal r_x_start_SS :   integer range pc_X_START_BORDER to pc_X_END_BORDER  :=pc_X_INITIAL_SS;
    signal w_x_start_ufo:   signed(pc_GAME_BITS downto 0)                       :=(others=>'0');
    signal r_x_start_UFO:   integer                                             :=0;
    signal r_ufo_active :   STD_LOGIC                                           :='1';
    signal w_bullets    :   pt_bullets_pack;
    signal w_invaders   :   pt_invaders_pack;
    signal w_poisons    :   pt_invaders_pack;
	 
    --Killing signals
    signal r_kill_invader  :    unsigned(pc_INV_LIMIT-1 downto 0)               :=(others=>'0');
    signal r_kill_bullet   :    unsigned(pc_BULLET_LIMIT-1 downto 0)            :=(others=>'0');
    signal r_kill_poison   :    unsigned(pc_INV_LIMIT-1 downto 0)               :=(others=>'0');
	 
	--Helper signals and constant
    signal r_start         :   STD_LOGIC                                        :='0';
    signal r_run_en        :    STD_LOGIC                                       :='0';
    signal r_lives         :    integer range 0 to 3                            :=3;
    signal r_counter       :    integer range 0 to pc_LOOSE_TIME                :=0;
    constant c_20bit_one   : unsigned(pc_INV_LIMIT-1 downto 0)                  :=(others=>'1');
    signal r_SM_reset : STD_LOGIC  :='0';

    begin
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
					r_start <= i_start;
					if i_reset = '1' then
                        --game gets reset
                        r_SM_reset <= '1';	

                        r_SM <= IDLE;
                        r_kill_invader <= (others=>'0');
                        r_kill_bullet <= (others=>'0');
                        r_kill_poison <= (others=>'0');
                        r_lives <= 3;
                        r_ufo_active <= '1';
							
						    
					else --if i_reset = '0'
					 
                        case r_SM is
                            when IDLE =>
                                --Start Frame of the Game
								r_SM_reset <= '0';		  
                                r_kill_invader <= (others=>'0');
                                r_kill_bullet <= (others=>'0');
                                r_kill_poison <= (others=>'0');
                                r_lives <= 3;
                                r_ufo_active <= '1';  

                                --By falling edge of the start switch, game starts.
                                if i_start = '1' and r_start = '0' then --i changed it to rising edge for testing
                                    r_SM <= GAME_RUNNING;
                                end if;

                            when GAME_RUNNING =>
                                ------------------------------------------
                                --Collision betwwen Invaders and Bullets
                                ------------------------------------------
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

                                --------------------------------------
                                --Collision between UFO and Bullets
                                --------------------------------------
                                for i in 0 to pc_BULLET_LIMIT-1 loop
                                    if w_bullets(i).Active = '1' then
                                        if r_ufo_ACTIVE = '1' then
                                            if w_bullets(i).X >= r_x_start_ufo and w_bullets(i).X < r_x_start_ufo + pc_UFO_WIDTH 
                                                and w_bullets(i).Y >= pc_Y_START_UFO and w_bullets(i).Y < pc_Y_END_UFO then
                                                    r_kill_bullet(i) <= '1';
                                                    r_ufo_active <= '0';
                                            end if;
                                        end if;
                                    else
                                        r_kill_bullet(i) <= '0';
                                    end if;
                                end loop;
                                    
                                --------------------------------------------
                                --Collision Between Space-Sheep and Poisons
                                --------------------------------------------
                                for i in 0 to pc_INV_LIMIT-1 loop
                                    if w_poisons(i).Active = '1' then
                                        if w_poisons(i).Y >= pc_Y_start_SS and w_poisons(i).Y <= pc_Y_END_SS 
                                        and w_poisons(i).X >= r_x_start_SS and w_poisons(i).X < r_X_start_SS + pc_SS_WIDTH then
                                                r_kill_poison(i) <= '1';
                                                r_SM <= LOOSE_LIVE;
                                        end if;			
                                    else
                                        r_kill_poison(i) <= '0';    
                                    end if;
                                end loop;

                                ---------------------------------------------
                                --Collision Between Space-Sheep and Invaders
                                ---------------------------------------------
                                for i in 0 to pc_INV_LIMIT -1 loop
                                    if w_invaders(i).ACTIVE = '1' then
                                        if w_invaders(i).Y + pc_INV_HEIGHT > pc_Y_start_SS and w_invaders(i).Y <= pc_Y_END_SS 
                                        and w_invaders(i).X >= r_x_start_SS and w_invaders(i).X < r_X_start_SS + pc_SS_WIDTH then
                                            r_SM <= LOOSE_LIVE;
                                        end if;
                                    end if;
                                end loop;
                                                
                                -----------------------------------------------------------------
                                --Winning Logic: If Space-sheep kill all the Invaders and the UFO
                                -----------------------------------------------------------------
                                if r_kill_invader = c_20bit_one and r_ufo_active = '0' then
                                    r_SM <= WINNING;
                                end if;


                            when LOOSE_LIVE =>
                                ---------------------------------------------------------
                                --Max 3 lives. if it loose all the lives, game is OVER.
                                ---------------------------------------------------------
                                if r_counter < pc_LOOSE_TIME then
                                    r_counter <= r_counter + 1;
                                else
                                    r_counter <= 0;
                                    if r_lives > 1 then
                                        r_lives <= r_lives - 1;
                                        r_SM <= GAME_RUNNING;
                                    else
                                        r_lives <= r_lives - 1;
                                        r_SM <= GAME_OVER;
                                    end if;
                                end if;
                                    

                            when WINNING =>
                                --By falling edge of the start switch, come back to start page.
                                if i_start = '1' and r_start = '0' then  --NOTEEEEE: changed to rising edge for test
                                    r_SM <= IDLE;
                                    r_SM_reset <= '1';
                                end if;

                            when game_OVER =>
                                
                                --By falling edge of the start switch, come back to start page.
                                if i_start = '1' and r_start = '0' then  --changed to rising edge for testing uart
                                    r_SM <= IDLE;
                                    r_SM_reset <= '1';
                                end if;

                            when others =>
                                r_SM <= IDLE;
                            end case;
                    end if;
				end if;
            end process;

           
        ---------------------------------------------
        --Enableing signals for each of states
        ---------------------------------------------
        o_start_en <= '1' when r_SM = IDLE else '0'; 
        r_run_en <= '1' when r_SM = GAME_RUNNING else '0';
        o_loose_live_en <= '1' when r_SM = LOOSE_LIVE else '0';
        o_win_en <= '1' when r_SM = WINNING else '0';
        o_end_en <= '1' when r_SM = GAME_OVER else '0';

        o_run_en <= r_run_en;
        o_lives <= r_lives;
        o_ufo_active <= r_ufo_active;


        -----------------------------------------
        --Movement of Space_Sheep
        -----------------------------------------
        space_sheep_movement: entity work.movement_spaceSheep
        port map (
            i_clk=> i_clk, --25MHZ
            i_reset=> r_SM_reset,
            i_en=> r_run_en,
            i_right_button=> i_right_btn,
            i_left_button=> i_left_btn,
            o_x_start_SS => w_x_start_SS
        );
        r_x_start_SS <= to_integer(w_x_start_SS);
        o_x_start_SS <= w_x_start_SS;
        
        -----------------------------------------
        --Movement of Bullets
        -----------------------------------------
        bullet_movement: entity work.movement_bullet
        port map(
            i_clk => i_clk,  --25MHz
            i_reset => r_SM_reset,
            i_en => r_run_en,
            i_x_ss => w_x_start_ss,
            i_bullet_button => i_bullet_btn,
				i_kill_bullet => r_kill_bullet,
            o_bullets => w_bullets
        );
        o_bullets <= w_bullets;

        -----------------------------------------
        --Movement of Invaders
        -----------------------------------------
        invaders_movement: entity work.movement_invaders
        port map(
            i_clk => i_clk,
            i_reset => r_SM_reset,
            i_en => r_run_en,
				i_kill_invader => r_kill_invader,
            o_invaders => w_invaders
        );
        o_invaders <= w_invaders;

        --------------------------------------------
        --Movement of Poisons
        --------------------------------------------
        poisons_movement: entity work.movement_poison
        port map(
            i_clk => i_clk,
            i_reset => r_SM_reset,
            i_en => r_run_en,
            i_invaders => w_invaders,
            i_kill_poison => r_kill_poison,
            o_poisons => w_poisons
        );
            o_poisons <= w_poisons;

        ----------------------------------------------
        --Movement of UFO
        ----------------------------------------------
        ufo_movement: entity work.movement_UFO
        port map(
            i_clk => i_clk,
            i_reset => r_SM_reset,
            i_en => r_run_en,
            o_x_start_UFO => w_x_start_UFO
        );
        r_x_start_ufo <= to_integer(w_x_start_ufo);
        o_x_start_ufo <= w_x_start_ufo;

    end RTL;