:- use_module(library(lists)).
:- use_module(library(between)).
/*
    The GameState should have a game board (standard is 7x7),
    it should also save the turn
    and the scores of each player

    Moves start with 0
*/

maplistlist(_,[]).
maplistlist(P, [H|T]) :- maplist(P,H), maplistlist(P, T).

lenght_(A, B) :- length(B, A).

isEqual(A, B) :- A = B.

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
/*
move(GameState, Move, NewGameState) :-
    nth0(1, GameState, Turn), Turn = 1, 
    nth0(0, GameState, GameBoard),
    nth0(2, GameState, Score),
    doMove(GameBoard, Move, Turn, NewGameBoard),
    NewGameState = [NewGameBoard, 2, Score];

    nth0(1, GameState, Turn), Turn = 2, 
        nth0(0, GameState, GameBoard),
        nth0(2, GameState, Score),
        doMove(GameBoard, Move, Turn, NewGameBoard),
        NewGameState = [NewGameBoard, 1, Score].
*/
move([GameBoard, Turn, Score], Move, NewGameState) :-
    Turn = 1,
    doMove(GameBoard, Move, Turn, NewGameBoard),
    calc_score(NewGameBoard, Move, 1, Score, NewScore),
    NewGameState = [NewGameBoard, 2, NewScore];

    Turn = 2, 
    doMove(GameBoard, Move, Turn, NewGameBoard),
    calc_score(NewGameBoard, Move, 2, Score, NewScore),
    NewGameState = [NewGameBoard, 1, NewScore].

calc_score(GameBoard, [MoveX,MoveY], Turn, [Score1, Score2], NewScore) :-        
    /* se completar uma linha */
    nth0(MoveX, GameBoard, Row), 
    \+ member('X', Row), 
    length(Row, L),
    add_score(L, Turn, [Score1, Score2], NewScore );

    /* se completar uma coluna */
    length(GameBoard, L),
    repeat,
    between(0, L, I),
    nth0(I, GameBoard, Row),
    nth0(MoveY, Row, Square),
    Square \= 'X',
    add_score(L, Turn, [Score1, Score2], NewScore );

    /* se completar uma diagonal direita */

    /* se completar uma diagonal esquerda */

    /* se nao completar nada*/
    NewScore = [Score1, Score2].

add_score(Points, Turn, [Score1, Score2], NewScore ) :-
    Turn=1, 
    NewScore1 is Score1+Points,
    NewScore = [NewScore1, Score2];

    Turn=2,
    NewScore2 is Score2+Points,
    NewScore = [Score1, NewScore2].


do_move(GameBoard, Move, Turn, NewGameBoard) :-
    nth0(0, Move, MoveX),
    nth0(1, Move, MoveY),
    nth0(MoveX, GameBoard, Line),
    nth0(MoveY, Line, SqSymb),
    SqSymb = 'X',
    NewSymbCode is (48 + Turn),
    char_code(NewSymb, NewSymbCode),
    replace(MoveY, Line, NewSymb, NewLine),
    replace(MoveX, GameBoard, NewLine, NewGameBoard).  

/*
    Used for testing:
    initial_state(3, S).
    S = [[['X','X','X'],['X','X','X'],['X','X','X']],1,[0,0]]
    move([[['X','X','X'],['X','X','X'],['X','X','X']],1,[0,0]], [1, 1], NewS).
*/
