library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.SI_pack.ALL;

entity space_invaders_top is
    port (
        i_clk   :   in      STD_LOGIC;
        i_reset :   in      STD_LOGIC;
        i_start :   in      STD_LOGIC;
        i_right_btn: in     STD_LOGIC;
        i_left_btn  :   in  STD_LOGIC;
        i_bullet_btn    :   in  STD_LOGIC;

        --hdmi
        o_hdmi_clk  :   out     STD_LOGIC;
        o_hdmi_HS  :   out     STD_LOGIC;
        o_hdmi_VS  :   out     STD_LOGIC;
        o_hdmi_DE  :   out     STD_LOGIC;
        o_hdmi_data_bus  :   out     unsigned(23 downto 0)

    );
end space_invaders_top;

architecture RTL of space_invaders_top is
    signal r_clk25  :   STD_LOGIC   :='0';
    signal w_start  :   STD_LOGIC   :='0';
    signal w_reset :   STD_LOGIC   :='0';
    signal w_x, w_y :   unsigned(pc_VGA_BITS-1 downto 0) :=(others=>'0');
    signal r_x, r_y :   unsigned(pc_GAME_BITS-1 downto 0) :=(others=>'0');
    signal w_x_start_SS :   unsigned(pc_GAME_BITS-1 downto 0) :=(others=>'0');


    signal w_de  :   STD_LOGIC   :='0';
    signal w_invaders : pt_invaders_pack;
    signal w_bullets : pt_bullets_pack;

    signal w_run_en  :   STD_LOGIC   :='0';
    signal w_loose_live_en :   STD_LOGIC   :='0';
    signal w_poisons : pt_invaders_pack;
    signal w_lives : integer;


    begin
        -----------------------------------
        --dividing the frequency
        -----------------------------------
        dividing_frequency: entity work.freq_divider
        generic map(
            g_CLK_CYCLES_FOR_HALF_PERIOD=> 1
        )
        port map(
            i_clk=> i_clk,  --50MHz
            o_clk=> r_clk25  --25MHz
        );

        ---------------------------------------
        --debouncing start and reset switches
        ---------------------------------------
        debouncing_start_switch : entity work.debounce_filter
        generic map(
            g_DEBOUNCE_LIMIT=> pc_DEBOUNCE_LIMIT
        )
        port map(
            i_clk=> i_clk,  --50MHz
            i_bouncy=> i_start,
            o_debounced=> w_start
        );

        debouncing_reset_switch : entity work.debounce_filter
        generic map(
            g_DEBOUNCE_LIMIT=> pc_DEBOUNCE_LIMIT
        )
        port map(
            i_clk=> i_clk,  --50MHz
            i_bouncy=> i_reset,
            o_debounced=> w_reset
        );

        ----------------------------------------
        --VGA Synchronization
        ----------------------------------------
        VGA_synchronization: entity work.HV_sync
        port map(
            i_clk25=> r_clk25,
            i_reset=> w_reset,
            o_x=> w_x,
            o_y => w_y,
            o_HS=> o_hdmi_HS,
            o_VS=> o_hdmi_VS,
            o_DE=> w_DE
        );

        r_x <= w_x(pc_VGA_BITS -1 downto 2); --dividing by 4
        r_y <= w_y(pc_VGA_BITS -1 downto 2); --dividing by 4


        -----------------------------------------
        --space invaders state machine
        -----------------------------------------
        SI_SM: entity work.space_invaders_SM
        port map(
            i_clk=> r_clk25,
            i_reset=> w_reset,
            i_start => w_start,
            i_right_btn => not i_right_btn,
            i_left_btn => not i_left_btn,
            i_bullet_btn => not i_bullet_btn,
            i_x => r_x,
            i_y => r_y,
            o_x_start_SS => w_x_start_SS,
            o_invaders => w_invaders,
            o_bullets => w_bullets,
            o_poisons => w_poisons,
            o_run_en => w_run_en,
            o_loose_live_en => w_loose_live_en,
            o_lives => w_lives
        );
            
        ----------------------------------------
        --drawing
        ----------------------------------------
        drwing_elements: entity work.draw_top
        port map(
            i_clk => r_clk25,
            i_en => w_run_en,
            i_Loose_live_en => w_loose_live_en,
            i_lives => w_lives,
            i_x => r_x,
            i_y => r_y,
            i_DE => w_DE,
            i_x_start_SS => w_x_start_SS,
            i_bullets => w_bullets,
            i_invaders => w_invaders,
            i_poisons => w_poisons,
            o_drawing_data_bus => o_hdmi_data_bus
        );

        o_hdmi_DE <= w_DE;
        o_hdmi_clk <= r_clk25;

    end RTL;