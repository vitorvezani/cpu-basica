LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;

ENTITY ula IS
PORT (
		A,BusWires: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Ulatype : IN STD_LOGIC;
		Result: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ula;

ARCHITECTURE Behavioral OF ula IS
BEGIN
	PROCESS (Ulatype, A, BusWires)
		BEGIN

		IF (Ulatype='1') THEN
			Result <= A+BusWires;
		ELSE
			Result <= A-BusWires;
			
		END IF;
	END PROCESS;
END Behavioral;