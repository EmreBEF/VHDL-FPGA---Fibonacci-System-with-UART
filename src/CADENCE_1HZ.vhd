-- =========================================================
-- Module      : CADENCE_1HZ
-- Description : Clock divider generating a 1 Hz enable pulse
--               from the FPGA system clock.
--
--               This module produces a single clock-cycle pulse
--               every second (1 Hz), based on a 50 MHz input clock.
--
--               It is used to slow down the Fibonacci sequence
--               generation so that values can be displayed at a
--               human-readable rate.
--
-- Inputs:
--   CLK    : System clock (50 MHz)
--   RAZ    : Active-low reset
--
-- Outputs:
--   SORTIE : 1 Hz pulse (1 clock cycle wide)
--
-- Notes:
--   The counter reaches 49,999,999 → 50,000,000 cycles total
--   → 50 MHz / 50,000,000 = 1 Hz
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CADENCE_1HZ is
    port(
        CLK    : in  std_logic;
        RAZ    : in  std_logic;
        SORTIE : out std_logic
    );
end CADENCE_1HZ;

architecture behavior of CADENCE_1HZ is
begin

    process(CLK)
        -- 26-bit counter for clock division
        variable compt : unsigned(25 downto 0);
    begin
        if rising_edge(CLK) then

            -- Active-low reset
            if RAZ = '0' then
                compt := (others => '0');
                SORTIE <= '0';

            else
                -- Generate a pulse every 50,000,000 clock cycles
                if compt = to_unsigned(49999999, 26) then
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