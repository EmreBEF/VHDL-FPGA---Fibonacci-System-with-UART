-- =========================================================
-- Module      : BaudGen
-- Description : Baud rate generator for UART communication.
--
--               This module generates a periodic enable pulse
--               (BaudEn) used to control the transmission rate
--               of the UART.
--
--               The baud rate can be selected using VITESSE:
--               - '0' → 9600 baud
--               - '1' → 19200 baud
--
--               The output BaudEn is a single clock-cycle pulse
--               generated at the selected baud rate.
--
-- Inputs:
--   CLK     : System clock (50 MHz FPGA clock)
--   VITESSE : Baud rate selector
--
-- Outputs:
--   BaudEn  : Enable pulse for UART transmission
--
-- Notes:
--   Counter values are computed based on a 50 MHz clock:
--   - 50e6 / 9600  ≈ 5208 → used value: 5207
--   - 50e6 / 19200 ≈ 2604 → used value: 2603
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BaudGen is
    port(
        CLK     : in  std_logic;
        VITESSE : in  std_logic;
        BaudEn  : out std_logic
    );
end BaudGen;

architecture behavior of BaudGen is
begin

    process(CLK)
        -- Counter used to divide the clock frequency
        variable compt : unsigned(12 downto 0);

        -- Store previous value of VITESSE to detect changes
        variable vitesse_old : std_logic := '0';
    begin
        if rising_edge(CLK) then

            -- Reset counter if baud rate selection changes
            if VITESSE /= vitesse_old then
                compt := (others => '0');
                BaudEn <= '0';

            -- Case: 9600 baud
            elsif VITESSE = '0' then
                if compt = to_unsigned(5207, 13) then
                    BaudEn <= '1';                -- Generate pulse
                    compt := (others => '0');     -- Reset counter
                else
                    BaudEn <= '0';
                    compt := compt + 1;
                end if;

            -- Case: 19200 baud
            else
                if compt = to_unsigned(2603, 13) then
                    BaudEn <= '1';                -- Generate pulse
                    compt := (others => '0');     -- Reset counter
                else
                    BaudEn <= '0';
                    compt := compt + 1;
                end if;
            end if;

            -- Update previous value
            vitesse_old := VITESSE;

        end if;
    end process;

end behavior;