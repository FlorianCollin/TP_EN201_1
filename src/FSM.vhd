library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is 
    Port (
        CLOCK : in std_logic;
        RESET : in std_logic;
        B_UP : in std_logic;
        B_DOWN : in std_logic;
        B_CENTER : in std_logic;
        B_LEFT : in std_logic;
        B_RIGHT : in std_logic;

        PLAY_PAUSE : out std_logic;
        RESTART : out std_logic;
        FORWARD : out std_logic;
        VOLUME_UP : out std_logic;
        VOLUME_DW : out std_logic
    );
end FSM;

architecture behav of FSM is

    type ETAT is (init, play_fwd, play_bwd, pause, stop);
    signal current_state : ETAT:=init;
    signal next_state : ETAT:=init;

    begin

        -- Processus combinatoire de calcul de l'etat futur
        Process_calcul_etat_futur: process(RESET, B_CENTER, B_LEFT, B_RIGHT, current_state)
        begin
            case current_state is 
                when init => 
                    if (B_CENTER='1') then
                        next_state <= play_fwd;
                    else next_state <= current_state;
                    end if;
                when play_fwd =>
                    if (B_CENTER='1') then
                        next_state <= pause;
                    else next_state <= current_state;
                    end if;
                when pause =>
                    if (B_LEFT='1') then
                        next_state <= play_bwd;
                    elsif (B_CENTER='1') then
                        next_state <= stop;
                    elsif (B_RIGHT='1') then
                        next_state <= play_fwd;
                    else next_state <= current_state;
                    end if;
                when stop =>
                    if (B_CENTER='1') then
                        next_state <= play_fwd;
                    else next_state <= current_state;
                    end if;
                when play_bwd =>
                    if (B_CENTER='1') then
                        next_state <= pause;
                    else next_state <= current_state;
                    end if;
            end case;
        end process Process_calcul_etat_futur;


        Process_etat_present: process(current_state, b_up, b_down)
        begin
            case current_state is
                when init =>
                    PLAY_PAUSE <= '0';
                    RESTART <= '1';
                    FORWARD <= '0';
                    VOLUME_UP <= '0';
                    VOLUME_DW <= '0';
                when play_fwd =>
                    PLAY_PAUSE <= '1';
                    RESTART <= '0';
                    FORWARD <= '1';
                    VOLUME_UP <= B_UP;
                    VOLUME_DW <= B_DOWN;
                when pause =>
                    PLAY_PAUSE <= '0';
                    RESTART <= '0';
                    FORWARD <= '0';
                    VOLUME_UP <= '0';
                    VOLUME_DW <= '0';
                when play_bwd =>
                    PLAY_PAUSE <= '1';
                    RESTART <= '0';
                    FORWARD <= '0';
                    VOLUME_UP <= B_UP;
                    VOLUME_DW <= B_DOWN;
                when stop =>
                    PLAY_PAUSE <= '0';
                    RESTART <= '1';
                    FORWARD <= '0';
                    VOLUME_UP <= '0';
                    VOLUME_DW <= '0';
            end case;
        end process Process_etat_present;

        Process_synchr: process(clock, reset)
        begin
            if (rising_edge(clock)) then
                if (RESET='1') then
                    current_state <= init;
                else current_state <= next_state;
                end if;
            end if;
        end process Process_synchr;

end behav;