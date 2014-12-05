= CPU BÁSICA = 

Este primeiro projeto tem objetivo implementar e simular uma CPU básica que realize quatro instruções:
MOV , ADD, SUB e XCHG. A instrução MOV deve mover um valor imediato para um registrador, a instrução ADD
deve somar o conteúdo de dois registradores, a instrução SUB deve subtrair o conteúdo entre dois registradores e
a instrução XCHG deve trocar o conteúdo de dois registradores entre si.Para implementar, serão necessários uma
Unidade de controle
Para realizar essas instruções foi preciso de uma Unidade de Controle, feita com uso de uma máquina de
estados, e uma Unidade Lógica Aritmética (ULA).