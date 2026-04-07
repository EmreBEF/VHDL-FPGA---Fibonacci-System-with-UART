-- =========================================================
-- Module      : Fibo_carry
-- Description : 16-bit Fibonacci sequence generator with
--               overflow detection.
--
--               This module generates Fibonacci numbers at
--               each clock cycle when EN = '1'.
--
--               The sequence is computed as:
--               F(n) = F(n-1) + F(n-2)
--
--               If an overflow occurs (result exceeds 16 bits),
--               the system resets the sequence and sets the
--               overflow flag.
--
-- Inputs:
--   Clk        : System clock
--   Raz        : Active-low reset
--   EN         : Enable signal (generation active when '1')
--   N          : Number of terms to generate (8-bit)
--
-- Outputs:
--   Suite      : Current Fibonacci value (16-bit)
--   Carry_flag : Overflow indicator
--
-- Notes:
--   - Overflow is detected using a 17-bit temporary sum
--   - When overflow occurs, the sequence restarts from 1
--   - Uses STD_LOGIC_UNSIGNED (non-standard but functional)
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Fibo_carry is
    port (
        Clk        : in  std_logic;
        Raz        : in  std_logic;  -- Reset signal
        EN         : in  std_logic;  -- Enable signal
        N          : in  std_logic_vector(7 downto 0); -- Number of terms
        Suite      : out std_logic_vector(15 downto 0); -- 16-bit output
        Carry_flag : out std_logic
    );
end Fibo_carry;

architecture behavioral of Fibo_carry is
begin
    process(Clk)

        -- Current Fibonacci term
        variable terme      : std_logic_vector(15 downto 0);

        -- Previous terms
        variable terme_1    : std_logic_vector(15 downto 0);
        variable terme_2    : std_logic_vector(15 downto 0);

        -- Counter for number of generated terms
        variable compt      : std_logic_vector(7 downto 0);

        -- Overflow flag
        variable overflow   : std_logic;

        -- Extended sum (17 bits) to detect overflow
        variable somme_test : std_logic_vector(16 downto 0);

    begin
        if rising_edge(Clk) then

            -- Active-low reset: initialize sequence
            if Raz = '0' then
                compt      := "00000000";
                terme      := "0000000000000001";
                terme_1    := "0000000000000001";
                terme_2    := "0000000000000000";
                overflow   := '0';

            -- Generate next Fibonacci term when enabled
            elsif EN = '1' then

                if compt < N then

                    -- Compute next term with overflow detection
                    somme_test := ('0' & terme_1) + ('0' & terme_2);

                    -- Check overflow (17th bit)
                    if somme_test(16) = '1' then
                        overflow := '1';

                        -- Reset sequence after overflow
                        compt      := "00000000";
                        terme      := "0000000000000001";
                        terme_1    := "0000000000000001";
                        terme_2    := "0000000000000000";

                    else
                        overflow := '0';

                        -- Update Fibonacci sequence
                        terme    := somme_test(15 downto 0);
                        terme_2  := terme_1;
                        terme_1  := terme;
                        compt    := compt + 1;
                    end if;

                end if;
            end if;

            -- Output assignments
            Suite <= terme;
            Carry_flag <= overflow;

        end if;
    end process;
end behavioral;