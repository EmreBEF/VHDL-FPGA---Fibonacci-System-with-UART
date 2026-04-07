-- =========================================================
-- Module      : CADENCE_1HZ_SIMU
-- Description : Simulation version of the 1 Hz clock divider.
--
--               This module is a simplified version of the
--               real CADENCE_1HZ block, intended only for
--               simulation.
--
--               Instead of waiting for 50,000,000 clock cycles,
--               it generates a pulse after only 10 cycles in
--               order to speed up waveform verification.
--
-- Inputs:
--   CLK    : Simulation clock
--   RAZ    : Active-low reset
--
-- Outputs:
--   SORTIE : Short periodic enable pulse
--
-- Notes:
--   This module is not intended for hardware use.
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CADENCE_1HZ_SIMU is
    port(
        CLK    : in  std_logic;
        RAZ    : in  std_logic;
        SORTIE : out std_logic
    );
end CADENCE_1HZ_SIMU;

architecture behavior of CADENCE_1HZ_SIMU is
begin

    process(CLK)
        -- Counter used for accelerated simulation timing
        variable compt : unsigned(25 downto 0);
    begin
        if rising_edge(CLK) then
            if RAZ = '0' then
                compt := (others => '0');
                SORTIE <= '0';
            else
                if compt = to_unsigned(10, 26) then
                    SORTIE <= '1';
                    compt := (others => '0');
                else
                    SORTIE <= '0';
                    compt := compt + 1;
                end if;
            end if;
        end if;
    end process;

end behavior;


-- =========================================================
-- Testbench   : TB_CADENCE
-- Description : Testbench for the CADENCE_1HZ_SIMU module.
--
--               This testbench generates a clock signal and
--               applies a reset pulse in order to verify the
--               behavior of the simulated clock divider.
--
-- Notes:
--   - Clock period = 1 ns
--   - Reset is held active at the beginning of simulation
--   - The simulation then runs long enough to observe output pulses
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_CADENCE is
end TB_CADENCE;

architecture behavior of TB_CADENCE is

    signal CLK    : std_logic := '0';
    signal RAZ    : std_logic := '0';
    signal SORTIE : std_logic;

begin

    -- Instantiate the device under test (DUT)
    DUT : entity work.CADENCE_1HZ_SIMU
        port map (
            CLK    => CLK,
            RAZ    => RAZ,
            SORTIE => SORTIE
        );

    -- Clock generation process
    CLK_process : process
    begin
        while true loop
            CLK <= '0';
            wait for 0.5 ns;
            CLK <= '1';
            wait for 0.5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Active reset
        RAZ <= '0';
        wait for 50 ns;

        -- Release reset
        RAZ <= '1';

        -- Let the simulation run
        wait for 500 ns;

        -- End simulation
        wait;
    end process;

end behavior;