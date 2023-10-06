library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Ce script n'est pas le vrai gestionaire de frequence
-- Il génere des frequence bien plus haute pour pouvoir faire des simulations moins 'lourde' !

-- Tcep = 100 * Th
-- Tcea = 10 * Th


-- Le vrai script ce trouve dans le dossier save/ 

entity gestion_freq is
    port(
        horloge : in std_logic; 
        raz : in std_logic; 
        ce_affichage : out std_logic; 
        ce_perception : out std_logic 
    );
end gestion_freq;

 
architecture behav of gestion_freq is
    signal count_affichage : unsigned(6 downto 0) :=  "0000000"; -- 100 = "1100100";
    signal count_perception : unsigned(3 downto 0) :=  "0000"; -- 10 = "1010";
      

begin

    process(horloge, raz)
    begin
        if rising_edge(horloge) then
            if raz = '1' then
                count_affichage <= "0000000";
                count_perception <= "0000";
                ce_perception <= '0';
                ce_affichage <= '0';
            else
                count_affichage <= count_affichage + 1;
                count_perception <= count_perception + 1;

                
                if count_perception = "1010" then
                    count_perception <= "0000";
                    ce_perception <= '1';
                else
                    ce_perception <= '0';
                end if;

                    
                if count_affichage = "1100100" then
                    count_affichage <= "0000000";
                    ce_affichage <= '1';
                else 
                    ce_affichage <= '0';
                end if;               
                
            end if;
        end if;
    end process;


end behav ;