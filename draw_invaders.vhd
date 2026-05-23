library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity draw_invaders is
    port (
        i_clk                   :   in      STD_LOGIC;
        i_en                    :   in      STD_LOGIC;
        i_x                     :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_y                     :   in      unsigned(pc_GAME_BITS-1 downto 0);
        i_invaders              :   in      pt_invaders_pack;
        o_draw_invaders_row1    :   out     unsigned(pc_INV_ROW_LIMIT -1 downto 0);
        o_draw_invaders_row2    :   out     unsigned(pc_INV_ROW_LIMIT -1 downto 0);
        o_draw_invaders_row3    :   out     unsigned(pc_INV_ROW_LIMIT -1 downto 0);
        o_draw_invaders_row4    :   out     unsigned(pc_INV_ROW_LIMIT -1 downto 0);
        o_draw_burst_invaders   :   out     unsigned(pc_INV_LIMIT -1 downto 0)
    );
end draw_invaders;

architecture RTL of draw_invaders is
    signal r_x  :   integer range 0 to pc_GAME_WIDTH -1  :=0;
    signal r_y  :   integer range 0 to pc_GAME_HEIGHT -1 :=0;

    signal r_invaders_activeness    : unsigned(pc_INV_LIMIT -1 downto 0)    :=(others=>'1');
    signal r_draw_burst             : unsigned(pc_INV_LIMIT -1 downto 0)    :=(others=>'0');
    signal r_burst_counter          : integer range 0 to pc_BURST_SPEED     :=0;
    signal r_frame                  : STD_LOGIC                             :='0';
    signal r_frame_counter          : integer range 0 to pc_INV_FRAME_SPEED :=0;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        -----------------------------------------------------------------------------------------------------------------------------
        --we cannot use for loop inside the concurrent environment, the for loops are allowed inside the process or generate blocks.
        --since I want my for loop to happen concurrently without depending on clock. i will put it inside a generate block.
        --The invaders are drawn row by row.
        -----------------------------------------------------------------------------------------------------------------------------
        --First row of invaders:
        gen_invaders_row1: for i in 0 to pc_INV_ROW1_LIMIT-1 generate
		  begin                      --frame 1 of invaders
                o_draw_invaders_row1(i) <= pc_invader_1_f1(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when i_invaders(i).ACTIVE = '1' and r_frame = '0'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH else

									--frame 2 of invaders			 
                                     pc_invader_1_f2(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when i_invaders(i).ACTIVE = '1'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH
                                        else '0';
        end generate;

        --Second row of invaders:
        gen_invaders_row2: for i in pc_INV_ROW1_LIMIT to pc_INV_ROW2_LIMIT-1 generate
		  begin                     --frame 1 of invaders
                o_draw_invaders_row2(i-pc_INV_ROW1_LIMIT) <= pc_invader_2_f1(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when i_invaders(i).ACTIVE = '1' and r_frame = '0'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH else

									--frame 2 of invaders			 
                                      pc_invader_2_f2(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X )
                                        when i_invaders(i).ACTIVE = '1'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH
                                        else '0';
        end generate;

        --Third row of invaders:
        gen_invaders_row3: for i in pc_INV_ROW2_LIMIT to pc_INV_ROW3_LIMIT-1 generate
		  begin                     --frame 1 of invaders
                o_draw_invaders_row3(i-pc_INV_ROW2_LIMIT) <= pc_invader_3_f1(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when i_invaders(i).ACTIVE = '1' and r_frame = '0'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH else

									--frame 2 of invaders	 
                                      pc_invader_3_f2(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X )
                                        when i_invaders(i).ACTIVE = '1'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH
                                        else '0';
        end generate;

        --Forth row of invaders
        gen_invaders_row4: for i in pc_INV_ROW3_LIMIT to pc_INV_ROW4_LIMIT-1 generate
		  begin                     --frame 1 of invaders
                o_draw_invaders_row4(i-pc_INV_ROW3_LIMIT) <= pc_invader_4_f1(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when i_invaders(i).ACTIVE = '1' and r_frame = '0'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH else

									--frame 2 of invaders
                                      pc_invader_4_f2(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when i_invaders(i).ACTIVE = '1'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH
                                        else '0';
        end generate;

        ----------------------------------------------------------------
        --Changing the frame of invaders every pc_INV_FRAME_SPEED time 
        ----------------------------------------------------------------
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if i_en = '1' then
                        if r_frame_counter < pc_INV_FRAME_SPEED then
                            r_frame_counter <= r_frame_counter + 1;
                        else
                            r_frame_counter <= 0;
                            r_frame <= not r_frame;
                        end if;
                    end if;
                end if;
            end process;

        -------------------------------------------------------------------------------------------------------
        --In falling edge of the ACTIVE signal, we determine that an invader has killed, so we draw a burst at 
        --that particular location. After some moment (PC_BURST_SPEED) , the bursting ends.
        -------------------------------------------------------------------------------------------------------
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    for i in 0 to pc_INV_LIMIT -1 loop
                        r_invaders_activeness(i) <= i_invaders(i).ACTIVE;
                    end loop;

                    for i in 0 to pc_INV_LIMIT -1 loop
                        if i_invaders(i).ACTIVE = '0' and r_invaders_activeness(i) = '1' then
							r_draw_burst(i) <= '1';
                        end if;
                        
                        if r_burst_counter < pc_BURST_SPEED then
                            r_burst_counter <= r_burst_counter + 1;
                        else 
                            r_burst_counter <= 0;
                            r_draw_burst(i) <= '0';
                        end if;
                    end loop;

                end if;
            end process;
				
        --------------------------------------------------------------
        --Draw the burst in the locations that an invader has killed
        --------------------------------------------------------------
        gen_burst: for i in  0 to pc_INV_LIMIT-1 generate
            o_draw_burst_invaders(i) <= pc_burst(r_y - i_invaders(i).Y )(r_x - i_invaders(i).X ) 
                                        when r_draw_burst(i) = '1'
                                        and r_y >= i_invaders(i).Y and r_y < i_invaders(i).Y + pc_INV_HEIGHT
                                        and r_x >= i_invaders(i).X and r_x < i_invaders(i).X + pc_INV_WIDTH
                                        else '0';
        
        end generate;


    end RTL;