library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity audio_top is
    port (
        --inputs
        i_clk50             :   in      STD_LOGIC;
        i_reset             :   in      STD_LOGIC;
        i_bullets   :   in  pt_bullets_pack;
        i_invaders     :   in      pt_invaders_pack;
        i_ufo_active    :   in      STD_LOGIC;
        i_death_sound_En     :   in      STD_LOGIC;
        i_gameover_sound_En    :   in      STD_LOGIC;
        i_win_sound_En    :   in      STD_LOGIC;
        
        --outputs
        o_MCLK              :   out     STD_LOGIC;
        o_LRCLK             :   out     STD_LOGIC;
        o_BCLK              :   out     STD_LOGIC;
        o_DATA              :   out     STD_LOGIC
    );
end audio_top;

architecture RTL of audio_top is
    signal w_LRCLK          : STD_LOGIC              :='0';

    --Sample Signals
	signal r_sample         : unsigned(23 downto 0)  :=(others=>'0');
    signal w_kill_invs_sample   : unsigned(23 downto 0)  :=(others=>'0');
	signal w_kill_UFO__sample    : unsigned(23 downto 0)  :=(others=>'0');
    signal w_bullet_sample   : unsigned(23 downto 0)  :=(others=>'0');
	signal w_death_sample    : unsigned(23 downto 0)  :=(others=>'0');
    signal w_gameover_sample   : unsigned(23 downto 0)  :=(others=>'0');
	signal w_win_sample    : unsigned(23 downto 0)  :=(others=>'0');

	--Data Valid signals
    signal w_kill_invs_DV       : STD_LOGIC              :='0';
    signal w_kill_UFO_DV        : STD_LOGIC              :='0';
    signal w_bullet_DV       : STD_LOGIC              :='0';
    signal w_death_DV        : STD_LOGIC              :='0';
    signal w_gameover_DV       : STD_LOGIC              :='0';
    signal w_win_DV        : STD_LOGIC              :='0';

    signal r_kill_invs_sound_en       : STD_LOGIC              :='0';
    signal w_kill_UFO_sound_en        : STD_LOGIC              :='0';
    signal w_bullet_sound_en       : STD_LOGIC              :='0';

	
    begin 
        process(i_clk50) is
            begin
                if rising_edge(i_clk50) then
                    --generate the enable signal for bullet sounds
                    for i in 0 to pc_BULLET_LIMIT -1 loop
                        r_bullets(i) <= i_bullets(i).ACTIVE;

                        if i_bullets(i).ACTIVE = '1' and r_bullets(i) = '0' then
                            r_bullet_sound_en <= '1';
                            exit;
                        else
                            r_bullet_sound_en <= '0';
                        end if;
                    end loop;

                    --generating enable signal for killing invaders sound
                    for i in 0 to pc_INV_LIMIT -1 loop
                        r_invaders(i) <= i_invaders(i).ACTIVE;

                        if i_invaders(i).ACTIVE = '0' and r_invaders(i) = '1' then
                            r_kill_invs_sound_en <= '1';
                            exit;
                        else
                            r_kill_invs_sound_en <= '0';
                        end if;
                    end loop;

                    --generating enable signal for killing ufo sound
                    r_ufo_active <= i_ufo_active;
                    if i_ufo(i).ACTIVE = '0' and r_ufo(i) = '1' then
                        r_kill_ufo_sound_en <= '1';
                    else
                        r_kill_ufo_sound_en <= '0';
                    end if;
                end if;
            end process;

        -------------------------------------------
        --Generating the sound for killing invaders
        --------------------------------------------
        killing_melody_generator: entity work.melody_gen
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_TONE => (27, 34, 48), --Corrosponds to 900Hz, 700Hz, 500Hz
            g_TONE_LIMIT => 3,                      --Maximum number of the tones
            g_DURATION_LIMIT => 2880                 --60ms
        )
        port map(
            i_clk => i_clk50,
            i_en => r_kill_invs_sound_en,
            i_LRCLK => w_LRCLK,
            o_sample => w_kill_invs_sample,
            o_sample_DV => w_kill_invs_DV
        );

        -------------------------------------------
        --Generating the sound for killing UFO
        --------------------------------------------
        killing_melody_generator: entity work.melody_gen
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_TONE => (20, 30, 53, 53), --Corrosponds to 1200Hz, 800Hz, 450Hz
            g_TONE_LIMIT => 4,                      --Maximum number of the tones
            g_DURATION_LIMIT => 2880                 --60ms
        )
        port map(
            i_clk => i_clk50,
            i_en => r_kill_UFO_sound_En,
            i_LRCLK => w_LRCLK,
            o_sample => w_kill_UFO_sample,
            o_sample_DV => w_kill_UFO_DV
        );

        -------------------------------------------
        --Generating the sound for player shooting
        -------------------------------------------
        bullet_melody_generator: entity work.melody_gen
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_TONE => (22, 22), --Corrosponds to 1100Hz
            g_TONE_LIMIT => 1,                           --Maximum number of the tones
            g_DURATION_LIMIT => 5760                     --120ms
        )
        port map(
            i_clk => i_clk50,
            i_en => r_bullet_sound_en,
            i_LRCLK => w_LRCLK,
            o_sample => w_bullet_sample,
            o_sample_DV => w_bullet_DV
        );

        -------------------------------------------------
        --Generating the sound for player death explosion
        -------------------------------------------------
        death_melody_generator: entity work.melody_gen
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_TONE => (20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120),  --Corrosponds to 200-1200Hz
            g_TONE_LIMIT => 11,                            --Maximum number of the tones
            g_DURATION_LIMIT => 1746                      --36ms
        )
        port map(
            i_clk => i_clk50,
            i_en => i_death_sound_En,
            i_LRCLK => w_LRCLK,
            o_sample => w_death_sample,
            o_sample_DV => w_death_DV
        );

        --------------------------------------
        --Generating the sound for game over
        --------------------------------------
        gameover_melody_generator: entity work.melody_gen
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_TONE => (120, 80, 60, 48, 40, 34, 30, 27, 24, 22, 20), --Corrosonds to 200Hz, 300Hz, . . . , 1200Hz
            g_TONE_LIMIT => 11,                                                  --Maximum number of the tones
            g_DURATION_LIMIT => 7200                                             --150ms
        )
        port map(
            i_clk => i_clk50,
            i_en => i_gameover_sound_En,
            i_LRCLK => w_LRCLK,
            o_sample => w_gameover_sample,
            o_sample_DV => w_gameover_DV
        );

        --------------------------------------
        --Generating the sound for winning
        --------------------------------------
        winning_melody_generator: entity work.melody_gen
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_TONE => (34, 27, 20), --Corrosonds to 700Hz, 900Hz, 1200Hz
            g_TONE_LIMIT => 3,                                                  --Maximum number of the tones
            g_DURATION_LIMIT => 7040                                             --146ms
        )
        port map(
            i_clk => i_clk50,
            i_en => i_win_sound_En,
            i_LRCLK => w_LRCLK,
            o_sample => w_win_sample,
            o_sample_DV => w_win_DV
        );

		--------------------------------------------
        --Transmitting the generated samples to DAC
        --------------------------------------------
        i2s_transmitter: entity work.i2s_tx
        generic map(
            g_SAMPLE_WIDTH => 24,
            g_HALF_PERIOD_MCLK => 2,  --12.5MHz 
            g_HALF_PERIOD_BCLK => 8   --3.1MHz
        )
        port map(
            i_clk => i_clk50,
            i_reset => i_reset,
            i_sample => r_sample,
            o_BCLK => o_BCLK,
            o_LRCLK => w_LRCLK,
            o_MCLK => o_MCLK,
            o_DATA => o_DATA
        );

        --------------------------------------------------------
        --Determine which sample should go to the I2s-Tx module
        --------------------------------------------------------
        r_sample <= w_bullet_sample when w_bullet_DV = '1' else
                    w_death_sample when w_death_DV = '1' else
                    w_kill_invs_sample when w_kill_invs_DV = '1' else
                    w_kill_UFO_sample when w_kill_UFO_DV = '1' else
                    w_gameover_sample when w_gameover_DV = '1' else
                    w_win_sample when w_win_DV = '1' else
					(others=>'0');

        o_LRCLK <= w_LRCLK;

    end RTL;