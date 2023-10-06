library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture behav of top_tb is
component top
    port (
        button_center : in std_logic;
        button_down : in std_logic;
        button_left : in std_logic;
        button_right : in std_logic;
        button_up : in std_logic;
        raz : in std_logic;
        horloge : in std_logic;
        
        sept_segments : out std_logic_vector(6 downto 0); -- sortie du mux8
        an : out std_logic_vector(7 downto 0) -- bus 8 bit
    );
end component;

signal button_center, button_down, button_left, button_right, button_up, raz, horloge : std_logic := '0';
signal sept_segments : std_logic_vector(6 downto 0);
signal  an : std_logic_vector(7 downto 0);

begin
    uut : top
    port map (
        button_center => button_center,
        button_down => button_down,
        button_left => button_left,
        button_right => button_right,
        button_up => button_up,
        raz => raz,
        horloge => horloge,

        sept_segments => sept_segments,
        an => an
    );
    
    clk_process: process
    begin
        horloge <= '1';
        wait for 5 ns;
        horloge <= '0';
        wait for 5 ns;
    end process;

    test: process
    begin
        raz <= '1';
        wait for 30 ns;
        raz <= '0';
        wait for 10 ns;
        button_center <= '1';
        wait for 50 ns;
        -- le laisser pendant 5 cycle d'horloge permet de verifier le bon fonctionnment de detect_impulsion !
        button_center <= '0';
        wait for 10 us; 
        -- permet de voir l'incrementation du temps sur nos  7 segments et sur s_time
        -- Maintenant on parcours nos différent états (voir fsm)
        button_center <= '1'; -- passage à l'etat 'pause'
        wait for 10 ns;
        button_center <= '0';
        wait for 10 us;
        button_left <= '1'; -- passage à l'état 'play_bwd'
        wait for 10 ns;
        button_left <= '0';
        wait for 10 us;
        button_center <= '1'; -- passage à l'état 'pause'
        wait for 10 ns;
        button_center <= '0';
        wait for 100 ns;
        button_center <= '1'; -- passage à l'état stop
        wait for 10 ns;
        button_center <= '0';
        wait for 100 ns;
        button_center <= '1'; -- passage à l'état play_fwd
        wait for 10 ns;
        button_center <= '0';
        wait for 100 ns;
        -- Maintenant on va parcourir les différents niveaux de volume
        
        wait;
    end process;

end behav;