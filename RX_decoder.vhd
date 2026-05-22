library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity RX_decoder is
    port (
        i_clk          :   in      STD_LOGIC;
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
    signal r_counter : integer range 0 to 2  :=0;
	 signal r_left_counter : integer   :=0;
	 signal r_right_counter : integer   :=0;
	 
	 signal r_start_btn : STD_LOGIC  :='0';
	 signal r_bullet_btn : STD_LOGIC  :='0';
	  signal r_left_btn : STD_LOGIC  :='0';
	 signal r_right_btn : STD_LOGIC  :='0';
 
    begin
	 
	 
 
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
					r_en <= i_en;
                    if i_en = '1' and r_en = '0' then
                        case i_ASCII_code is
                            when "00100000" =>      --0x20 Space Key
                                r_bullet_btn <= '1';
										  

                            when "00001101" =>      --0x0D Enter Key
                                r_start_btn <= '1';
										  

                            when "00110001" =>      --0x31 Digit 1 Key
                                r_left_btn <= '1';
										  r_right_btn <= '0';

                            when "00110011" =>      --0x33 Digit 3 Key
                                r_right_btn <= '1';
										  r_left_btn <= '0';
                            
                            when others =>
                                r_left_btn <= '0';
										  r_right_btn <= '0';
                            end case;
                    end if;
                        
                            r_start_btn <= '0';
                            r_bullet_btn <= '0';
                        

                end if;
            end process;
				o_left_btn <= r_left_btn;
				o_right_btn <= r_right_btn;
				o_bullet_btn <= r_bullet_btn;
				o_start_btn <= r_start_btn;
				
				

    end RTL;