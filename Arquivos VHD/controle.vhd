LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE work.components.all ;

ENTITY controle IS
PORT ( DATA      :   IN    STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
       Resetn 	 :   IN    STD_LOGIC;
       Clock     :   IN    STD_LOGIC;
       Start	 :   IN    STD_LOGIC;
       BusWires  :   INOUT STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
       Register1,Register2,Register3: OUT STD_LOGIC_VECTOR (3 DOWNTO 0):=(OTHERS => '0'));
END controle ;

ARCHITECTURE Behavior OF controle IS

	TYPE state_type IS (inicial, mov, add1, add2, add3, sub1, sub2, sub3, xchg1, xchg2, xchg3, final);
	SIGNAL w	 : state_type ;
	SIGNAL Rin, Rout : STD_LOGIC_VECTOR(1 TO 3) ;
	SIGNAL Ulatype : STD_LOGIC;
	SIGNAL R1, R2, R3, Aux, Aux2, Result : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Auxin,Extern, Aux2in, Aux2out    :    STD_LOGIC := '0';

BEGIN

		reg1:   regn PORT MAP   (BusWires, Rin(1), Clock, R1 );
		tri1:   trin PORT MAP   (R1, Rout(1), BusWires );

		reg2:   regn PORT MAP   (BusWires, Rin(2), Clock, R2 );
		tri2:   trin PORT MAP   (R2, Rout(2), BusWires );

		reg3:   regn PORT MAP   (BusWires, Rin(3), Clock, R3 );
		tri3:   trin PORT MAP   (R3, Rout(3), BusWires );
		
		regT1:  regn PORT MAP  (BusWires, AUXin, Clock, Aux);
		triT1:  trin PORT MAP  (DATA(3 DOWNTO 0), Extern, BusWires );
		
		regT2:  regn PORT MAP  (Result, Aux2in, Clock, Aux2);
		triT2:  trin PORT MAP  (Aux2, Aux2out, BusWires );
		
		opula: ula PORT MAP    (Aux, BusWires, Ulatype, Result); 

		PROCESS(Resetn, Clock)
		BEGIN
			IF Resetn='1'THEN
			   w<=Inicial;
			
			ELSIF(clock'EVENT AND Clock='1')THEN
			
			 CASE w IS
				WHEN inicial =>
				
				IF Start = '1' THEN -- Sinal para que aconteca o start da funcao
			
					CASE DATA(7 DOWNTO 6)IS -- case na operacao (UPCODE) para ver que operacao sera realizada
						WHEN "00" => -- opcode 00 = move
					   	
					  		Extern <= '1';  -- Coloca IMEDIADO na BusWires
							
							w <= mov;	-- Troca estado mov

		    		    WHEN "01" => 	-- opcode 01 = add

							w <= add1; 	-- Troca estado para add1

						WHEN "10" => 	-- opcode 10 = sub

							w <= sub1; 	-- Troca estado para sub1
		
						WHEN "11" => 	-- opcode 11 = xchg
						  					 	
							w <= xchg1; -- Troca estado para xchg1
					END CASE;
				END IF;
				
				WHEN mov => -- Estado mov
					
						IF DATA(5 DOWNTO 4)="00" THEN     
					           Rin(1)<='1';					--Abre escrita no Registrador 1			
							
						ELSIF DATA(5 DOWNTO 4)="01"  THEN 
					           Rin(2)<='1';					--Abre escrita no Registrador 2
						       	  
						ELSIF DATA(5 DOWNTO 4)="10" THEN  
						   Rin(3)<='1';						--Abre escrita no Registrador 3
						END IF;
					
					w <= final; -- Estado final
				        							
				WHEN add1 => -- Estado add1
									        
						Rout(1) <= '1';	-- Abre leitura no escrita
						Auxin <= '1';	-- Abre leitura no Registrador Temporario 1
						Ulatype <= '1';	-- Tipo da operacao (1 = add)
						
					w <= add2;			--Troca de estado para add2		

				WHEN add2 => -- Estado add2

					Auxin <= '0'; 	-- Fecha Registrador Auxiliar 1 para leitura
					Aux2in <= '1'; 	-- Abre Registrador Auxiliar 2 para leitura
					Rout(1) <= '0'; -- Fecha Registrador 1 para escrita no barramento
					Rout(2) <= '1'; -- Abre registrador 2 para escrita no barramento

				    w <= add3;
				    
				WHEN add3 =>  -- Estado add3
				
						Rout(2) <= '0'; -- Fecha Registrador 2 para escrita
						Rin(1) <= '1'; 	-- Abre Registrador 1 para leitura
						Aux2out <= '1'; -- Abre registrador Auxiliar 2 para escrita
   						
				    w <= final;
	
				WHEN sub1 =>  -- Estado sub1
										        
					Rout(1) <= '1';	-- Abre Registrador 1 para escrita
					Auxin <= '1';	-- Abre Registrador Auxiliar 1 para leitura
					Ulatype <= '0';	-- Tipo da operacao (0 = sub)
					
				   w <= sub2;

				WHEN sub2 =>  -- estado sub2
					
					Auxin <= '0'; 	-- fecha o Registrador Auxiliar 1 para leitura
					Aux2in <= '1'; 	-- abre Registrador Auxiliar 2 para leitura
					Rout(1) <= '0'; -- fecha Registrador 1 para escrita no barramento
					Rout(2) <= '1'; -- abre-se o Registrador 2 para escrita no barramento

				   w <= sub3;


				WHEN sub3 =>  -- estado sub3
						
					Rout(2) <= '0'; -- fecha Registrador 2 para escrita
					Rin(1) <= '1'; 	-- abre Registrador 1 para leitura
					Aux2out <= '1'; -- abre Registrador Auxiliar 2 para escrita
   						
				    w <= final;
				    
				
				
				
				WHEN xchg1 => -- xchg
					Rout(1) <= '1'; -- abre Registrador 1 para escrita
					Rin(3) <= '1'; 	-- abre Registrador 3 leitura   
					w <=xchg2;		-- troca estado para xchg2				

				WHEN xchg2 =>
					Rout(1) <= '0'; -- fecha Registrador 1 para escrita
   					Rin(3) <= '0';	-- fecha Registrador 3 para leitura
   					Rin(1) <='1';	-- abre Registrador 1 para leitura
   			 		Rout(2) <='1'; 	-- abre Registrador 2 para escrita
   			 		w <= xchg3;		--troca esado para xchg3

				WHEN xchg3=>
					Rout(2) <= '0'; -- fecha Registrador 2 para escrita
   					Rin(1) <= '0'; 	-- fecha Registrador 1 para leitura
   					Rin(2) <= '1'; 	-- abre Registrador 2 para leitura
   					Rout(3) <= '1'; -- abre Registrador 3 para escrita
   			 		w <= final;		-- termino do xchg, troca estado para final

				WHEN final =>
					Rin(1) <= '0';	-- fecha Registrador 1 para leitura
   					Rin(2) <= '0';	-- fecha Registrador 2 para leitura
   				 	Rin(3) <= '0';	-- fecha Registrador 3 para leitura
   				 		
					Auxin <= '0';	-- fecha leitura Registrador Auxiliar 1
   					Aux2in<= '0';	-- fecha leitura Registrador Auxiliar 2
   				 	Extern <= '0';	-- fecha Extern para escrita
   					Aux2out<= '0';  -- fecha registrador Auxiliar 2 para escrita
   				 
   				    	Rout(1) <= '0';	-- fecha Registrador 1 para escrita
   				 	Rout(2) <= '0';	-- fecha Registrador 2 para escrita
   				 	Rout(3) <= '0';	-- fecha Registrador 3 para escrita
   				 	
					w <= inicial;			
			END CASE;
		END IF;
	END PROCESS;
	
	Register1 <= R1; 	--Saida auxiliar recebe valor do registrador 1
	Register2 <= R2;  	--Saida auxiliar2 recebe valor do registrador 2
	Register3 <= R3; 	--Saida auxiliar3 recebe valor do registrador 3

END Behavior;
