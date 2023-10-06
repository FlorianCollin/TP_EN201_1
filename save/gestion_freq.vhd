library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gestion_freq is
    port(
        horloge : in std_logic; -- f = 100 MHz / Th = 10 ns 
        raz : in std_logic; -- remise à zero synchrone sur l'horloge
        ce_affichage : out std_logic; -- f = 10 Hz / T = 100 ms = 1 000 000 * Th / pour l'actualisation du compteur cpt_1_599
        ce_perception : out std_logic -- f = 3 kHz / T = 333 333 ns ~= 33 333 * Th
        -- pour la creation de signal de commande du mux produit par le compteur modulo 8 (frequence de balayage des  7 seg)
    );
end gestion_freq;

 
architecture behav of gestion_freq is
    signal count_affichage : unsigned(19 downto 0) := "00000000000000000000"; -- compteur permettant de compter jusqu'a 1 000 000 
    signal count_perception : unsigned(15 downto 0) := "0000000000000000";
      

begin

    process(horloge, raz)
    begin
        if rising_edge(horloge) then
            if raz = '1' then
                count_affichage <= "00000000000000000000";
                count_perception <= "0000000000000000";
                ce_perception <= '0';
                ce_affichage <= '0';

            else
                count_affichage <= count_affichage + 1;
                count_perception <= count_perception + 1;
                
                if count_perception = "1000001000110101" then
                    count_perception <= "0000000000000000";
                    ce_perception <= '1';
                else
                    ce_perception <= '0';
                end if;

                if count_affichage = "11110100001001000000" then
                    count_affichage <= "00000000000000000000";
                    ce_affichage <= '1';
                else
                    ce_affichage <= '1';
                end if;

            end if;
        end if;

    end process;


end behav ;