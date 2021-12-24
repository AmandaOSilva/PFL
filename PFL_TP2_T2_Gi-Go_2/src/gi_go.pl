:- use_module(library(lists)).

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

move(GameState, Move, NewGameState) :-
    nth0(1, GameState, Turn), Turn = 1, 
        nth0(0, GameState, GameBoard),
        nth0(2, GameState, Score),
        doMove(GameBoard, Move, Turn, NewGameBoard),
        NewGameState = [NewGameBoard, 2, Score];

    nth0(1, GameState, Turn), Turn = 2, 
        nth0(0, GameState, GameBoard),
        nth0(2, GameState, Score),
        NewGameState = [GameBoard, 1, Score].


doMove(GameBoard, Move, Turn, NewGameBoard) :-
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