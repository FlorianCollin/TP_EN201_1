library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cpt_1_599_tb is
end cpt_1_599_tb;

architecture behav of cpt_1_599_tb is
component cpt_1_599
    port (
        c_e : in std_logic;
        decr, incr : in std_logic;
        init : in std_logic;
        horloge : in std_logic;
        raz : in std_logic;
        sortie : out std_logic_vector(9 downto 0)
    );
end component;

signal c_e, decr, incr, horloge, raz, init: std_logic := '0';
signal sortie : std_logic_vector(9 downto 0);


begin
    uut: cpt_1_599
        port map (
            c_e => c_e,
            decr => decr,
            incr => incr,
            init => init,
            horloge => horloge,
            raz => raz,
            sortie => sortie
        );
    
    c_e_process: process -- freq 10 Hz periode 100 ms
    begin
        c_e <= '0';  -- Initial state
        wait for 47 ns;  -- Wait for 45 ns before starting c_e
        loop
            c_e <= '1';  -- Set c_e to '1' for 10 ns
            wait for 10 ns;
            c_e <= '0';  -- Set c_e to '0' for 90  en realité 99999990ns mais trop lourd pour la simu
            wait for 90 ns;
        end loop;
    end process c_e_process;

    horloge_process: process --fréquence d'horloge 100MHz => 10ns de periode
    begin
        horloge <= '0';  -- Initial state
        wait for 5 ns;      -- Half-period for 100 MHz
        while now < 500 ms loop  -- Simulate for 500 ms (100 ms period)
            horloge <= not horloge; -- Toggle the clock signal
            wait for 5 ns;  -- 5 ns half-period for 100 MHz
        end loop;
        wait;
    end process horloge_process;

    test: process
    begin
        incr <= '1';
        decr <= '0';
        wait for 500 ns;
        decr <= '1';
        incr <= '0';
        wait for 200 ns;
        decr <= '0';
        incr <= '1';
        wait for 500 ns;
        wait;
    end process test;

end behav;

        

