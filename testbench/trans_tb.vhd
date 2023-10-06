library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trans_tb is
end entity;



architecture behav of trans_tb is
component trans
port (
    forward, play_pause, restart : in std_logic;
    nb_binaire : in std_logic_vector(9 downto 0); -- sortie de cpt_1_599
    nb_binaire_volume : in std_logic_vector(3 downto 0); --sortie de cpt_1_9
    s_cent, s_diz, s_unit : out std_logic_vector(6 downto 0);
    s_unit_vol : out std_logic_vector(6 downto 0);
    sortie1, sortie2, sortie3, sortie4 : out std_logic_vector(6 downto 0)
);
end component;

signal forward, play_pause, restart :  std_logic;
signal nb_binaire : std_logic_vector(9 downto 0); 
signal nb_binaire_volume : std_logic_vector(3 downto 0);
signal s_cent, s_diz, s_unit : std_logic_vector(6 downto 0);
signal s_unit_vol : std_logic_vector(6 downto 0);
signal sortie1, sortie2, sortie3, sortie4 : std_logic_vector(6 downto 0);

begin
    uut: trans
    port map (
        forward => forward,
        play_pause => play_pause,
        restart => restart,
        nb_binaire => nb_binaire,
        nb_binaire_volume => nb_binaire_volume,
        s_cent => s_cent,
        s_diz => s_diz,
        s_unit => s_unit,
        s_unit_vol => s_unit_vol,
        sortie1 => sortie1,
        sortie2 => sortie2,
        sortie3 => sortie3,
        sortie4 => sortie4
    );

    test: process
    begin
        nb_binaire <= "0011110011"; -- 243
        nb_binaire_volume <= "1001"; -- 9
        wait for 10 ns;
        nb_binaire <= "0000100110" ; -- 38
        wait for 10 ns;
        wait;
    end process;
end behav;