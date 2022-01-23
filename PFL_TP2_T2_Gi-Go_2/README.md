# GI-GO

Este jogo de tabuleiro foi realizado no ambito da disciplina de prolog, somos da turma 2 e somos o grupo Gi_GO_2.

### Developers:
| Nome | Número mecanografo | Divisão de trabalho |
|---|---|---|
| Amanda de Oliveira Silva | [up201800698](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201800698)| 50% |
| Rafael Fernando Ribeiro Camelo | [up201907729](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201907729) | 50% |

## Instalação e execução

Para jogar a nossa versão do *Gi-Go* apenas é necessário instalar o [SICStus Prolog 4.7](https://sicstus.sics.se)

## Descrição do jogo
Os jogadores devem prencher um campo por vez no tabuleiro, até que o todos os campos estejam preenchidos.O objetivo do jogo é fechar o maior número possível de linhas horizontais, verticais ou diagonais, ou seja, colocar a última pedra. Se você fechar uma linha, obterá o número de campos na linha como pontos. Quando todos os campos estiverem ocupados, o jogador com mais pontos vence.

## Lógica do jogo 2400pl

## Representação interna do estado do jogo 

O tabuleiro é reprentado por um matrix de "X"s, que correspondem a um campo nao preenchido. O tamanha formado apartir do input do usúario.


```
initial_state(3, S).
    S = [[['X','X','X'],['X','X','X'],['X','X','X']],1,[0,0]]
```


A contagem dos pontos (score) é armazenada em uma lista, inicializada como [0,0] onde o índice (nth1) corresponde a pontucao de cada Jogador.


```
initial_state(Size, GameState) :-
    length(GameBoard, Size),
    maplist(lenght_(Size), GameBoard),
    maplistlist(isEqual('X'), GameBoard),
    Turn = 1,
    Score = [0, 0],
    GameState = [GameBoard, Turn, Score].
```



## Visualização do estado do jogo


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