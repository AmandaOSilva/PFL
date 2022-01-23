# GI-GO

Este jogo de tabuleiro foi realizado no ambito da disciplina de prolog, somos da turma 2 e somos o grupo Gi_GO_2.

### Developers:
| Nome | Número mecanografo | Divisão de trabalho |
|---|---|---|
| Amanda de Oliveira Silva | [up201800698](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201800698)| 50% |
| Rafael Fernando Ribeiro Camelo | [up201907729](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201907729) | 50% |

## Instalação e execução

Para jogar a nossa versão do *Gi-Go* apenas é necessário instalar o [SICStus Prolog 4.7](https://sicstus.sics.se) e, depois de consultar o ficheiro, correr o comando ``play``.


## Descrição do jogo

Gi-go é um jogo de tabuleiro para dois jogadores. Os jogadores devem colocar peças no tabuleiro, normalmente o tabuleiro de jogo é constituido 7x7 quadrados, alternando a vez entre si, o jogo acaba quando todos os quadrados esteja preenchidos. O objetivo do jogo é fechar o maior número possível de linhas horizontais, verticais ou diagonais, ou seja, colocar a última pedra nessa mesma linha, coluna ou diagonal. Se você fechar uma linha, obterá o número de campos na linha como pontos. Quando todos os campos estiverem ocupados, o jogador com mais pontos vence.
[Página do jogo](https://boardgamegeek.com/boardgame/348086/gi-go).


## Lógica do jogo

### Representação interna do estado do jogo 

* O estado do jogo é separado em três partes:
    1. O **tabuleiro**: é reprentado por um matrix de carateres. Inicialmente está preenchida com "X"s, que correspondem a um campo nao preenchido. O tamanho é escolhido pelo usuário.
    2. O **turno**: indica quem deve fazer a próxima jogada.
    3. Os **scores**: guarda a pontuação de cada jogador, na primeira posição está a pontuação do jogador 1 e na segunda a do jogador 2.


Estado inicial com tamanho de campo 7:

![Initial_state7](./images/initial_state7.png)


Estado inicial com tamanho de campo 3:

![Initial_state3](./images/initial_state3.png)

As peças de um jogador estão diferenciadas, apesar de não ser necessário. As peças colocadas pelo jogador 1 estão guardadas com um "1" e as do jogador 2 com um "2".

### Visualização do estado do jogo

A visualização do jogo é feita com recurso a uma função ``display_game(GameState)``. A representação visual do jogo constitui:
* A declaração do turno, ou seja, quem vai fazer a próxima jogada.
* Exposição da pontuação atual dos jogadores. 
* Desenho do campo de jogo atual, com indicação das linhas e colunas, espaços vazios estão marcados com um "X" e as jogadas com "1" ou "2" dependendo de quem a realizou.


Visualização de um jogo no estado inicial, tamanho do campo 7x7:

![Display_initialGameState3x3](./images/Display_initialGameState7x7.png)


Visualização de um jogo no estado inicial, tamanho do campo 3x3:

![Display_initialGameState3x3](./images/Display_initialGameState3x3.png)


Ao iniciar um novo jogo o usuário é apresentado com um menu. Neste menu é pedido que ele introduza o tamanho do tabuleiro, que escolha o modo de jogo e, caso seja necessário, escolha a dificuldade do computador.

Menu inicial do jogo, modo de jogo humano contra humano:

![MenuInicial_hxh](./images/MenuInicial_hxh.png)

Menu inicial do jogo, modo de jogo humano contra máquina:

![MenuInicial_hxm](./images/MenuInicial_hxm.png)



## Execução de jogadas
É solicitado ao jogador que insira as coodenas da jogada a ser feita. [X,Y]
Será subtituido na matrix o "1" ou "2", a depender do jogador,  o "X" indicando que esse campo foi preenchido.
```
do_move(GameBoard, [MoveX,MoveY], Turn, NewGameBoard) :-
    nth0(MoveX, GameBoard, Line),
    nth0(MoveY, Line, SqSymb),
    SqSymb = 'X',
    NewSymbCode is (48 + Turn),
    char_code(NewSymb, NewSymbCode),
    replace(MoveY, Line, NewSymb, NewLine),
    replace(MoveX, GameBoard, NewLine, NewGameBoard).  
```
Um turno estará completo após ser calculado e somando o pontuacao da jogada e a variavel "Turn" for modificada para o proximo jogador.

```
move([GameBoard, Turn, Score], Move, NewGameState) :-
    is_valid_move(GameBoard, Move),
    do_move(GameBoard, Move, Turn, NewGameBoard),
    calc_score(NewGameBoard, Move, Turn, Score, NewScore),
    NewTurn is (Turn mod 2) + 1,    
    NewGameState = [NewGameBoard, NewTurn, NewScore].
```
## Final do jogo

O jogo encontra-se encerrado quando nao houver mais campos vazios, todos foram preenchidos.
O vencedor será aquele com a maior pontuacao.
```
game_over(GameState, Winner):-
    valid_moves(GameState, ListOfMoves),
    length(ListOfMoves, 0),
    nth0(2, GameState, Scores),
    maximum_at(Scores, Max, Winner).

``` 


## Lista de jogadas válidas
Uma jogada será valida se ainda nao estiver preenchida, campo diferente de "X".

Para isso percorremos a matrix do tabuleiro (GameBoard), e é verificado se o campo da jogada tem como valor "X", se a jodada é permitida e  validada.

```
/* valid_move(+GameState, -ValidMove) */
valid_move([GameBoard,_,_], ValidMove) :-
    length(GameBoard, L),
    L1 is L - 1,
    between(0, L1, X),
    between(0, L1, Y),
    is_valid_move(GameBoard, [X, Y]),
    ValidMove = [X, Y].
```

Na lista de jogadas validas ( ListOfMoves), é adicionado todos os movimentos que cumprem a condicao anteriomente explicada.

```
/* valid_moves(+GameState, -ListOfMoves) */
valid_moves(GameState, ListOfMoves) :-
    findall(ValidMove, valid_move(GameState, ValidMove), ListOfMoves).
```

### Avaliação do estado do jogo
### jogada do computador

## Conclusões