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
    signal w_run_en  :   STD_LOGIC   :='0';
    signal w_invaders : pt_invaders_pack;
    signal w_bullets : pt_bullets_pack;

    signal w_draw_invaders : unsigned(pc_INV_LIMIT-1 downto 0);
    signal w_draw_bullets : unsigned(pc_BULLET_LIMIT -1 downto 0);
    signal w_draw_SS : STD_LOGIC  :='0';
	 
	 constant c_20_bit_zero  :  unsigned(pc_INV_LIMIT-1 downto 0) :=(others=>'0');
	 constant c_8_bit_zero   :  unsigned(pc_BULLET_LIMIT-1 downto 0) :=(others=>'0');
	 

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
            o_run_en => w_run_en
        );

        -----------------------------------------
        --movement of space_sheep
        -----------------------------------------
        space_sheep_movement: entity work.movement_spaceSheep
        port map (
            i_clk=> r_clk25, --25MHZ
            i_reset=> w_reset,
            i_en=> w_run_en,
            i_right_button=> not i_right_btn,
            i_left_button=> not i_left_btn,
            i_x => r_x,
            i_y=> r_y,
            o_x_start_SS => w_x_start_SS
        );
        
        -----------------------------------------
        --movement of bullets
        -----------------------------------------
        bullet_movement: entity work.movement_bullet
        port map(
            i_clk => r_clk25,  --25MHz
            i_reset => w_reset,
            i_en => w_run_en,
            i_x_ss => w_x_start_ss,
            i_bullet_button => not i_bullet_btn,
            o_bullets => w_bullets
        );

        -----------------------------------------
        --movement of invaders
        -----------------------------------------
        invaders_movement: entity work.movement_invaders
        port map(
            i_clk => r_clk25,
            i_reset => w_reset,
            i_en => w_run_en,
            o_invaders => w_invaders
        );

        

        -----------------------------------------
        --draw space sheep
        ----------------------------------------
        drawing_SS: entity work.draw_spaceSheep
        port map(
            i_x => r_x,
            i_y=> r_y,
            i_x_start_SS => w_x_start_ss,
            o_draw_SS =>w_draw_SS
        );

        ----------------------------------------
        --draw bullets
        ----------------------------------------
        drawing_bullets: entity work.draw_bullets
        port map(
            i_bullets => w_bullets,
            i_x => r_x,
            i_y => r_y,
            o_draw_bullets => w_draw_bullets
        );

        -----------------------------------------
        --draw invaders
        -----------------------------------------
        drawing_invaders: entity work.draw_invaders
        port map(
            i_invaders => w_invaders,
            i_x => r_x,
            i_y => r_y,
            o_draw_invaders => w_draw_invaders
        );
		  
		  o_hdmi_data_bus <= (others=>'1') when w_de = '1' and (w_draw_SS = '1' or w_draw_invaders /=c_20_bit_zero or w_draw_bullets /=c_8_bit_zero) 
		  else (others=>'0');
		  
		  
        o_hdmi_DE <= w_DE;
        o_hdmi_clk <= r_clk25;






    end RTL;