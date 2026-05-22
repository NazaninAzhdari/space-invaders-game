library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
    begin
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
						r_en <= i_en;
                    if i_en = '1' and r_en = '0' then
                        case i_ASCII_code is
                            when "00100000" =>      --0x20 Space Key
                                o_bullet_btn <= '1';

                            when "00001101" =>      --0x0D Enter Key
                                o_start_btn <= '1';

                            when "00110001" =>      --0x31 Digit 1 Key
                                o_left_btn <= '1';

                            when "00110011" =>      --0x33 Digit 3 Key
                                o_right_btn <= '1';
                            
                            when others =>
                                o_start_btn <= '0';
                                o_bullet_btn <= '0';
                                o_left_btn <= '0';
                                o_right_btn <= '0';
                            end case;
                    --else
                    --    o_start_btn <= '0';
                     --   o_bullet_btn <= '0';
                     --   o_left_btn <= '0';
                     --   o_right_btn <= '0';
                    end if;
                end if;
            end process;

    end RTL;