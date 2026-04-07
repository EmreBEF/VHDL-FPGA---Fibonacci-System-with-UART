-- =========================================================
-- Module      : CADENCE_9600
-- Description : Clock divider generating a pulse at a rate
--               corresponding to 9600 baud.
--
--               This module divides the FPGA system clock
--               (50 MHz) to produce a periodic enable pulse
--               suitable for UART communication at 9600 baud.
--
-- Inputs:
--   CLK    : System clock (50 MHz)
--   RAZ    : Active-low reset
--
-- Outputs:
--   SORTIE : Baud rate enable pulse (1 clock cycle wide)
--
-- Notes:
--   For a 50 MHz clock:
--   50e6 / 9600 ≈ 5208 clock cycles per bit
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CADENCE_9600 is
    port(
        CLK    : in  std_logic;
        RAZ    : in  std_logic;
        SORTIE : out std_logic
    );
end CADENCE_9600;

architecture behavior of CADENCE_9600 is
begin

    process(CLK)
        -- Counter used for clock division
        variable compt : unsigned(25 downto 0);
    begin
        if rising_edge(CLK) then

            -- Active-low reset
            if RAZ = '0' then
                compt := (others => '0');
                SORTIE <= '0';

            else
                -- Generate pulse at ~9600 baud rate
                if compt = to_unsigned(5208, 13) then
                    SORTIE <= '1';              -- 1-cycle pulse
                    compt := (others => '0');   -- Reset counter
                else
                    SORTIE <= '0';
                    compt := compt + 1;
                end if;
            end if;

        end if;
    end process;

end behavior;