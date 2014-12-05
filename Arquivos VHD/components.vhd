LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

PACKAGE components IS
COMPONENT regn -- register
	GENERIC ( N : INTEGER := 4 );
PORT 	 (R :          IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	  Rin, Clock : IN  STD_LOGIC;
	  Q :          OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) );
END COMPONENT ;

COMPONENT trin --tri-state buffers
	GENERIC ( N : INTEGER := 4 ) ;
PORT (X : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	  E : IN  STD_LOGIC ;
	  F : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT ;

COMPONENT ula
PORT (
		A,BusWires: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Ulatype   : IN STD_LOGIC;
		Result: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;

END components;
