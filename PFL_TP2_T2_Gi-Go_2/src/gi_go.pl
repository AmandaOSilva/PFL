:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(aggregate)).
:- use_module(library(random)).

/*

    The GameState should have a game board (standard is 7x7),
    it should also save the turn
    and the scores of each player

    Moves start with 0
*/

maximum_at(L, M, I) :- nth1(I, L, M), \+ (member(E, L), E > M).

maplistlist(_,[]).
maplistlist(P, [H|T]) :- maplist(P,H), maplistlist(P, T).

lenght_(A, B) :- length(B, A).

isEqual(A, B) :- A = B.
   

%% Code from http://www.emse.fr/~picard/cours/ai/minimax/#sec-3


mirror_gameboard([X|[]], [RevX]) :-
    rev(X, RevX).    
mirror_gameboard([X|Xs], Mirror) :-
    rev(X, RevX),
    mirror_gameboard(Xs, MirrorXs), !,
    Mirror = [RevX|MirrorXs].

    
mirror_move(Move, Size, MirrorMove):-
    nth0(1, Move, OldY),
    NewY is Size - OldY - 1,
    replace(1, Move, NewY, MirrorMove).
    
replace(Index, OgList, ReplaceTo, NewList) :-
  nth0(Index, OgList, _, Helper),
  nth0(Index, NewList, ReplaceTo, Helper).

initial_state(Size, GameState) :-
    length(GameBoard, Size),
    maplist(lenght_(Size), GameBoard),
    maplistlist(isEqual('X'), GameBoard),
    Turn = 1,
    Score = [0, 0],
    GameState = [GameBoard, Turn, Score].

move([GameBoard, Turn, Score], Move, NewGameState) :-
    is_valid_move(GameBoard, Move),
    do_move(GameBoard, Move, Turn, NewGameBoard),
    calc_score(NewGameBoard, Move, Turn, Score, NewScore),
    NewTurn is (Turn mod 2) + 1,    
    NewGameState = [NewGameBoard, NewTurn, NewScore].

calc_score(GameBoard, Move, Turn, Score, NewScore) :-
    calc_score_row(GameBoard, Move, Turn, Score, PartialNewScore1),
    calc_score_column(GameBoard, Move, Turn, PartialNewScore1, PartialNewScore2),
    calc_score_diagonal(GameBoard, Move, Turn, PartialNewScore2, PartialNewScore3),
    mirror_gameboard(GameBoard, MirrorGameBoard),
    length(GameBoard, Size),
    mirror_move(Move, Size, MirrorMove),
    calc_score_diagonal(MirrorGameBoard, MirrorMove, Turn, PartialNewScore3, NewScore),
    !.

calc_score_row(GameBoard, [MoveX, _], Turn, Score, NewScore) :-
    %print('Rol'),
    /* se completar uma linha */
    nth0(MoveX, GameBoard, Row), 
    \+ member('X', Row), 
    length(Row, L),
    %print('Row: ' + Row),
    add_score(L, Turn, Score, NewScore);

    /* se nao completar nada*/
    NewScore = Score.

calc_score_column(GameBoard, [_, MoveY], Turn, Score, NewScore) :-
    %print('Col. Y=' + MoveY),
    length(GameBoard, L),
    repeat,
        between(0, L, I), 
        %print('Col: i= ' + I),
        nth0(I, GameBoard, Row),
        nth0(MoveY, Row, Square),
        (
            Square = 'X',
            /* ha um quadrado em branco*/
            NewScore = Score;

            I =:= L-1,
            /* se completar uma coluna */
            add_score(L, Turn, Score, NewScore)         
        ).

calc_score_diagonal(GameBoard, [MoveX,MoveY], Turn, Score, NewScore) :-
    /* se completar uma diagonal direita */
    length(GameBoard, L),
    Diff is MoveY-MoveX,
    DiagMax is L - abs(Diff),
    ( 
        Diff >= 0,
        repeat,
            between(0, DiagMax, I),
            nth0(I, GameBoard, Row),
            ColNumber is I + Diff,
            nth0(ColNumber, Row, Square),
            %print(' Diag R: I='+ I + ' colNumber= ' + ColNumber + ' Row' + Row+'\n'),
            (
                Square = 'X',
                %print('Col: row= ' + Row),
                /* ha um quadrado em branco*/
                NewScore = Score;

                I =:= DiagMax-1,
                /* se completar uma coluna */
                add_score(DiagMax, Turn, Score, NewScore)         
            );

        Diff < 0,
        repeat,
            between(0, DiagMax, I),
            RowNumber is I - Diff,
            nth0(RowNumber, GameBoard, Row),
            nth0(I, Row, Square),
            %print(' Diag R2: I='+ I + ' rowNumber= '+ RowNumber+' Row='+Row),
            (
                Square = 'X',
                %print('Col: row= ' + Row),
                /* ha um quadrado em branco*/
                NewScore = Score;

                I =:= DiagMax-1,
                /* se completar uma diagonal */
                add_score(DiagMax, Turn, Score, NewScore)         
            )
    ).


add_score(Points, Turn, [Score1, Score2], NewScore ) :-
    Turn=1, 
    NewScore1 is Score1 + Points,
    NewScore = [NewScore1, Score2];

    Turn=2,
    NewScore2 is Score2 + Points,
    NewScore = [Score1, NewScore2].


do_move(GameBoard, [MoveX,MoveY], Turn, NewGameBoard) :-
    nth0(MoveX, GameBoard, Line),
    nth0(MoveY, Line, SqSymb),
    SqSymb = 'X',
    NewSymbCode is (48 + Turn),
    char_code(NewSymb, NewSymbCode),
    replace(MoveY, Line, NewSymb, NewLine),
    replace(MoveX, GameBoard, NewLine, NewGameBoard).  

is_valid_move(GameBoard, [MoveX,MoveY]) :-
    nth0(MoveX, GameBoard, Row),
    nth0(MoveY, Row, Square),
    Square = 'X'.

/* valid_moves(+GameState, -ListOfMoves) */
valid_moves(GameState, ListOfMoves) :-
    findall(ValidMove, valid_move(GameState, ValidMove), ListOfMoves).


/* valid_move(+GameState, -ValidMove) */
valid_move([GameBoard,_,_], ValidMove) :-
    length(GameBoard, L),
    L1 is L - 1,
    between(0, L1, X),
    between(0, L1, Y),
    is_valid_move(GameBoard, [X, Y]),
    ValidMove = [X, Y].

display_game(GameState):-
    write('\n'),
    nth0(0, GameState, GameBoard),
    nth0(1, GameState, Turn), 
    nth0(2, GameState, Score),
    write('Turn = '),
    write(Turn),
    writeScores(Score),
    write('\nCurrent Game Board:\n\n'),
    nth0(0, GameBoard, Row),
    write('R\\C '),
    writeBoardInfoCol(Row, 0),
    write('\n'),
    writeBoard(GameBoard, 0),
    write('\n').

writeScores(Score):-
    nth0(0, Score, P1Score),
    nth0(1, Score, P2Score), 
    write('\n'),
    write('Player 1 score: '),
    write(P1Score),
    write('\n'),
    write('Player 2 score: '),
    write(P2Score),
    write('\n').


writeBoard([], _):-!.
writeBoard([Row|[]], Index):-
    write('\n '),
    write(Index),
    write('  '),
    writeBoardRow(Row),
    write('\n').
writeBoard([Row|RestBoard], Index):-
    write('\n '),
    write(Index),
    write('  '),
    writeBoardRow(Row),
    write('\n    '),
    writeRowSeparator(Row),
    Next is Index + 1,
    writeBoard(RestBoard, Next).

writeBoardRow([]):- !.
writeBoardRow([H|[]]):-
    write(' '),
    write(H).
writeBoardRow([H|T]):-
    write(' '),
    write(H),
    write(' |'),
    writeBoardRow(T).

writeRowSeparator([]):- !.
writeRowSeparator([_|[]]):- 
    write('---').
writeRowSeparator([_|T]):- 
    write('---|'),
    writeRowSeparator(T).

writeBoardInfoCol([], _):- !.
writeBoardInfoCol([_|[]], Num):- 
    write(' '),
    write(Num),
    write(' ').
writeBoardInfoCol([_|T], Num):-
    write(' '),
    write(Num),
    write('  '),
    Next is Num + 1,
    writeBoardInfoCol(T, Next).

/*
    Used for testing:
    
*/

play:-
    write('\nHello! Wellcome to Gi-Go.\n\n'),
    menu(BoardSize),
    initial_state(BoardSize, GameState),
    display_game(GameState),
    game_cycle(GameState).

game_cycle(GameState):-
    game_over(GameState, Winner), !,
    format('winner is player ~w!!!', [Winner]).
game_cycle(GameState):-
    choose_move(GameState, Move),
    move(GameState, Move, NewGameState),
    %next_player(Player, NextPlayer),
    display_game(NewGameState), !,
    game_cycle(NewGameState).


game_over(GameState, Winner):-
    valid_moves(GameState, ListOfMoves),
    length(ListOfMoves, 0),
    nth0(2, GameState, Scores),
    maximum_at(Scores, _, Winner).

random_select(Moves, Move) :-
    length(Moves, Lenght),
    random(0, Lenght, Index), !,
    nth0(Index, Moves, Move).

choose_move(1, _GameState, Moves, Move):-
    random_select(Moves, Move).

choose_move(2, GameState, Moves, Move):-
    setof(Value-Mv, NewState^( member(Mv, Moves),
        move(GameState, Mv, NewState),
        evaluate_board(NewState, Value) ), [_V-Move|_]).

choose_move([GameBoard, Turn, Score], Move):-
    machine(Turn),
    machine_level(Level),
    valid_moves([GameBoard, Turn, Score], Moves),
    choose_move(Level, [GameBoard, Turn, Score], Moves, Move).
    
choose_move([GameBoard, Turn, _], Move):-
    repeat,
    format('Player ~d choose your move row: ', [Turn]),
    read(MoveX),
    format('Player ~d choose your move col: ', [Turn]),
    read(MoveY),
    Move = [MoveX, MoveY],
    is_valid_move(GameBoard, Move), !.

menu(BoardSize):-
    choose_boardSize(BoardSize),
    choose_GameMode(GameMode),
    handle_GameMode(GameMode).


choose_machineLevel(Level):-
    write('Choose the difficulty of your AI oponent:\n1. Random.\n2. Best moves only.\n'),
    read(Level),
    valid_machineLevel(Level), !.

valid_machineLevel(Level):-
    Level > 0,
    Level < 3 .

handle_GameMode(1):-
    retractall(machine(_)),
    retractall(machine_level(_)).

handle_GameMode(2):-
    retractall(machine(_)),
    retractall(machine_level(_)),
    assert(machine(2)),
    choose_machineLevel(Level),
    assert(machine_level(Level)).

handle_GameMode(3):-
    retractall(machine(_)),
    retractall(machine_level(_)),
    assert(machine(1)),
    choose_machineLevel(Level),
    assert(machine_level(Level)).
    
handle_GameMode(4):-
    retractall(machine(_)),
    retractall(machine_level(_)),
    assert(machine(1)),
    assert(machine(2)),
    choose_machineLevel(Level),
    assert(machine_level(Level)).



choose_GameMode(GameMode):-
    repeat,
    write('How would you like to play?\n1. Human vs Human\n2. Human vs Machine\n3. Machine vs Human\n4. Machine vs Machine\n'),
    read(GameMode),
    valid_GameMode(GameMode), !.

valid_GameMode(GameMode):-
    GameMode > 0,
    GameMode < 5 .

choose_boardSize(BoardSize):-
    repeat,
    write('Choose your prefered Board Size: '),
    read(BoardSize),
    valid_boardSize(BoardSize), !.

valid_boardSize(BoardSize):-
    BoardSize > 2,
    BoardSize < 10 .


:- use_module(library(plunit)).

:- begin_tests(test).
     
test(mirror_gameboard) :-
    mirror_gameboard(
        [['1','2','3'],['4','5','6'],['7','8','9']], 
        [['3','2','1'],['6','5','4'],['9','8','7']]).

test(initial_state) :-
    initial_state(3, [[['X','X','X'],['X','X','X'],['X','X','X']], 1, [0,0]]),
    initial_state(7, [[
        ['X','X','X','X','X','X','X'],
        ['X','X','X','X','X','X','X'],
        ['X','X','X','X','X','X','X'],
        ['X','X','X','X','X','X','X'],
        ['X','X','X','X','X','X','X'],
        ['X','X','X','X','X','X','X'],
        ['X','X','X','X','X','X','X']], 1, [0,0]]).

test(is_valid_move_sucess) :- 
    is_valid_move([['X','X','X'],['X','X','X'],['X','X','X']], [0,0]).

test(is_valid_move_fail, fail) :- 
    is_valid_move([['1','X','X'],['X','X','X'],['X','X','X']], [0,0]).

test(move_no_score) :- 
    move(
        [[['X','X','X'],['X','X','X'],['X','X','X']], 1, [0,0]], [1, 1], 
        [[['X','X','X'],['X','1','X'],['X','X','X']], 2, [0,0]]), !.

test(move_row_score) :- 
    move([[['2','X','X'],['1','X','1'],['X','X','X']], 2, [0,0]], [1, 1], 
         [[['2','X','X'],['1','2','1'],['X','X','X']], 1, [0,3]]), !.

test(move_col_score) :- 
    move([[['2','X','1'],['X','X','1'],['X','X','X']], 2, [0,0]], [2, 2], 
         [[['2','X','1'],['X','X','1'],['X','X','2']], 1, [0,3]]), !.

test(valid_moves) :-
    valid_moves([[['1','X','X'],['X','X','X'],['X','X','2']],1,[0,0]], 
        [[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1]]).

test(valid_moves_empty) :-
    valid_moves([[['1','2','1'],['1','2','2'],['2','1','2']],1,[0,0]], 
        []).

:- end_tests(test).

% move([[['2','X','X'],['1','1','X'],['X','X','X']], 2, [0,0]], [2, 2], [[['2','X','X'],['1','2','X'],['X','X','2']], 1, [0,3]]).
/*
    initial_state(7, State), 
    display_game(State), 
    move(State, [5, 0], NewState),
    display_game(NewState), 
    move(NewState, [6, 1], NewState2), 
    display_game(NewState2).
*/
