-- =========================================================
-- Module      : seven_seg
-- Description : 4-bit to 7-segment display decoder.
--
--               This module converts a 4-bit binary input
--               into the corresponding 7-segment display
--               pattern.
--
--               It supports hexadecimal values (0 to F).
--
-- Inputs:
--   in4  : 4-bit binary input value
--
-- Outputs:
--   seg7 : 7-segment display output (active-low)
--
-- Notes:
--   - Output is active-low (0 = segment ON)
--   - Segment order is defined as (0 to 6)
--   - Covers full hexadecimal range (0–F)
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_seg is
    port(
        in4  : in  std_logic_vector(3 downto 0);
        seg7 : out std_logic_vector(0 to 6)
    );
end seven_seg;

architecture behavioral of seven_seg is
begin
    process(in4)

        -- Temporary variable holding segment pattern
        variable seg : std_logic_vector(0 to 6);

    begin
        case in4 is

            -- Decimal digits (0 to 9)
            when "0000" => seg := "0000001"; -- 0
            when "0001" => seg := "1001111"; -- 1
            when "0010" => seg := "0010010"; -- 2
            when "0011" => seg := "0000110"; -- 3
            when "0100" => seg := "1001100"; -- 4
            when "0101" => seg := "0100100"; -- 5
            when "0110" => seg := "0100000"; -- 6
            when "0111" => seg := "0001111"; -- 7
            when "1000" => seg := "0000000"; -- 8
            when "1001" => seg := "0000100"; -- 9

            -- Hexadecimal characters (A to F)
            when "1010" => seg := "0001000"; -- A
            when "1011" => seg := "1100000"; -- b
            when "1100" => seg := "0110001"; -- C
            when "1101" => seg := "1000010"; -- d
            when "1110" => seg := "0110000"; -- E
            when "1111" => seg := "0111000"; -- F

            -- Default case: all segments OFF
            when others => seg := "1111111";

        end case;

        -- Assign output (explicit bit ordering)
        seg7 <= seg(6) & seg(5) & seg(4) & seg(3) &
                seg(2) & seg(1) & seg(0);

    end process;

end behavioral;