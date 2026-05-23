library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity RX_decoder is
    port (
        i_clk          :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_en           :   in      STD_LOGIC; 
        i_ASCII_code   :   in      unsigned(7 downto 0);
        o_start_btn    :   out     STD_LOGIC;
        o_bullet_btn   :   out     STD_LOGIC;
        o_right_btn    :   out     STD_LOGIC;
        o_left_btn     :   out     STD_LOGIC
    );
end RX_decoder;

architecture RTL of RX_decoder is
	signal r_en : STD_LOGIC  :='0';
    signal r_start_timer : integer  :=0;
    signal r_bullet_timer : integer :=0;
	 signal r_left_timer : integer   :=0;
	 signal r_right_timer : integer   :=0;
	 
	 signal r_start_btn : STD_LOGIC  :='0';
	 signal r_bullet_btn : STD_LOGIC  :='0';
	  signal r_left_btn : STD_LOGIC  :='0';
	 signal r_right_btn : STD_LOGIC  :='0';
 
    begin
	 
	 
 
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
					r_en <= i_en;

                    if i_reset = '1' then 
                        r_left_timer <= 0;
                        r_right_timer <= 0;
                        r_start_timer <= 0;
                        r_bullet_timer <= 0;

                    elsif i_en = '1' and r_en = '0' then
                        case i_ASCII_code is
                            --the space key is dedicated for firing the bullet. our bullet logic works with 
                            --falling edge of the bullet button. so when space key is preesed. we set the timer to be one.
                            --in this way, the bullet btn goes high for one clock cycle and become low after it.
                            --the bullet logic will detect the falling edge after becoming low and fires the bullet.
                            when "00100000" =>      --0x20 Space Key
                                
                                r_bullet_timer <= 1;
										  
                            --exactly same as the bullet btn
                            when "00001101" =>      --0x0D Enter Key
                                
                                r_start_timer <= 1;
										  
                            --the digit 1 is dedicated to moving to left.
                            --the left btn logic of the game works in a way that you have to hold the button for 
                            --PC_SS_SPEED clock cycle,then it move one pixel to left.
                            --so here when the digit one is pressed we have to hold the btn to high state for PC_SS_SPEED
                            --to move the SS one pixel to left.
                            --since i wanted to increase the velocity of space sheep
                            --i am multiplying the SPEEd with velocity 
                            --so for example if you want to move the SS 4 pixel to left by each press, then you put the velocity to be 4

                            when "00110001" =>      --0x31 Digit 1 Key
                                
                                r_left_timer <= (pc_SS_SPEED)*pc_SS_VELOCITY;
								r_right_timer <= 0;

                                --exactly the same as left btn
                            when "00110011" =>      --0x33 Digit 3 Key
                                
                                r_right_timer <= (pc_SS_SPEED)*pc_SS_VELOCITY;
								r_left_timer <= 0;
                            
                            when others =>
                                null;
                            end case;
                    end if;

                    if r_bullet_timer > 0 then
								r_bullet_btn <= '1';
                        r_bullet_timer <= r_bullet_timer- 1;
                    else
                        r_bullet_btn <= '0';
                    end if;

                    if r_start_timer > 0 then
								r_start_btn <= '1';
                        r_start_timer <= r_start_timer- 1;
                    else
                        r_start_btn <= '0';
                    end if;

                    if r_left_timer > 0 then
								r_left_btn <= '1';
								
                        r_left_timer <= r_left_timer- 1;
                    else
                        r_left_btn <= '0';
                    end if;

                    if r_right_timer > 0 then
								r_right_btn <= '1';
								
                        r_right_timer <= r_right_timer- 1;
                    else
                        r_right_btn <= '0';
                    end if;
						
                end if;
            end process;

				o_left_btn <= r_left_btn;
				o_right_btn <= r_right_btn;
				o_bullet_btn <= r_bullet_btn;
				o_start_btn <= r_start_btn;
	

    end RTL;