-- =========================================================
-- Testbench   : tb_PROJET
-- Description : Simulation testbench for the seven_seg module.
--
--               This testbench applies all hexadecimal input
--               values from 0 to F to verify the 4-bit to
--               7-segment decoder behavior.
--
-- Inputs tested:
--   0000 to 1111  -> 0 to F
--
-- Notes:
--   - Each input value is applied for 10 ns
--   - No clock is required for this combinational module
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_PROJET is
end tb_PROJET;

architecture sim of tb_PROJET is

    -- Test signals
    signal in4_T  : std_logic_vector(3 downto 0);
    signal seg7_T : std_logic_vector(0 to 6);

begin

    -- Instantiate the unit under test (UUT)
    uut: entity work.seven_seg
        port map(
            in4  => in4_T,
            seg7 => seg7_T
        );

    -- Stimulus process
    process
    begin

        -- Test values 0 to 9
        in4_T <= "0000"; wait for 10 ns;
        in4_T <= "0001"; wait for 10 ns;
        in4_T <= "0010"; wait for 10 ns;
        in4_T <= "0011"; wait for 10 ns;
        in4_T <= "0100"; wait for 10 ns;
        in4_T <= "0101"; wait for 10 ns;
        in4_T <= "0110"; wait for 10 ns;
        in4_T <= "0111"; wait for 10 ns;
        in4_T <= "1000"; wait for 10 ns;
        in4_T <= "1001"; wait for 10 ns;

        -- Test values A to F
        in4_T <= "1010"; wait for 10 ns;
        in4_T <= "1011"; wait for 10 ns;
        in4_T <= "1100"; wait for 10 ns;
        in4_T <= "1101"; wait for 10 ns;
        in4_T <= "1110"; wait for 10 ns;
        in4_T <= "1111"; wait for 10 ns;

        -- End of simulation
        wait;

    end process;

end sim;