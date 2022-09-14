# ==========================================
# Project: implementation of a linked-list in Assembly MIPS
# Authors (GitHub):
# Gabriel Perao (gabrielperao)
# Raphael Leveque (raphaelleveque)
# Joao Pedro Nunes (joaoduarteN)
# Pedro Batista (pedrodbatista)
# ==========================================

    .data
    .align 2
mensagemInicial:            .asciiz "Inicio\n"
opcoes:                     .asciiz "\nMenu de Opcoes\nDigite:\n1) Adicionar um no na lista\n2)Imprimir a lista\n3) Sair\n"
imprimindo:                 .asciiz "\nImprimindo todos os nos da lista: "
breakline:                  .asciiz "\nString: "
mensagemId:                 .asciiz "\nID: "
mensagemErro:               .asciiz "Erro: A lista esta vazia\n"
mensagemIncompleto:         .asciiz "\n\nInsira ao menos 5 elementos na lista!!\n\n"
mensagemInsercao1:          .asciiz "Escolha o id do no\n"
mensagemInsercao2:          .asciiz "Escolha a string do no (Ate 30 Caracteres)\n"
mensagemNumeroInsercoes:    .asciiz "Digite ao menos 5 informações na lista!"
mensagemInsercaoSucesso:    .asciiz "\n.\nCampos adicionados com sucesso!\n.\n"


	.text
main:
                                                    # $t7 servirá como um contador para avaliar quantas informações foram inseridas.
                                                    # Para que a lista seja impressa, devem ser inseridas ao menos 5 informações
	move $t7, $zero
	
menu:
    la $a0, opcoes                                  # Imprime a mensagem de opcoes
    jal printString
    
                                                    # Le a entreda do usuario
    li $v0, 5
    syscall
	
	
    move $t0, $v0

    beq $t0, 1, addNode
    beq $t0, 2, verificaQuantidade	
    beq $t0, 3, exit
	
addNode:
    addi $t7, $t7, 1                                # Incrementamos o contador: mais um elemento adicionado
    
    li $v0, 9
    li $a0, 40                                      # Aloca 30 Bytes para string, 4 para o ponteiro, 4 para o ID
    syscall

    move $t1, $v0

    sw $zero, 36($t1)                               # Inicializa o ponteiro o proximo na para zero

                                                    # Imprime a mensagem de insercao do id
    la $a0, mensagemInsercao1
    jal printString

    li $v0, 5
    syscall
    sw $v0, 32($t1)                                 # Insere o ID no no

                                                    # Imprime a mensagem de insercao da palavra
    la $a0, mensagemInsercao2
    jal printString

                                                    # Insere a palavra no no
    li $v0, 8
    la $a0, 0($t1)
    li $a1, 30
    syscall

                                                    # Se $s7 for zero, entao o header da lista esta vazio, ou seja, lista vazia
                                                    # Senao atribui-se ao no anterior o ponteiro para o no inserido
    beqz $s7, primeiroNo
    la $t4, 0($t1)
    sw $t4, 36($s3)

    la $s3, 0($t1)

    j menu

primeiroNo:
    la $a0, mensagemInsercaoSucesso
    jal printString

    la $s7, ($t1)                                   # Se for o primeiro inicializa o valor de $s7 para o inicio da lista
    la $s3, ($t1)

    j menu

erro:
    la $a0, mensagemErro                            # Imprime mensagem que a lista esta vazia
    jal printString
    j menu

incompleto:
    la $a0, mensagemIncompleto                      # Imprime mensagem que a lista possui menos de 5 elementos
    jal printString
    j menu

verificaQuantidade:
    beq $t7, $zero, erro                            # Verifica se a lista esta vazia
    blt $t7, 5, incompleto                          # Verifica se a lista possui menos de 5 elementos
    bge $t7, 5, imprime                             # Imprime a lista

imprime:
    la $t1, ($s7)                                   # Imprimindo todos os elementos da lista
    beqz $t1, erro
    la $a0, imprimindo
    jal printString

imprimeAux:                                         # Funcao auxiliar para imprimir a lista, imprimindo strings e id's
    la $a0, mensagemId 
    jal printString

    lw $a0, 32($t1)
    jal printInt

    la $a0, breakline
    jal printString

    la $a0, 0($t1)
    jal printString


    lw $t2, 36($t1)
    beqz $t2, exit

    move $t1, $t2

    j imprimeAux

exit:                                               #  Funcao para finalizar o programa
    li $v0, 10           
    syscall	

printInt:
    li $v0, 1
    syscall
    jr $ra
	
printString:
    li $v0, 4
    syscall
    jr $ra
	
