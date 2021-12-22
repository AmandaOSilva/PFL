:- use_module(library(lists)).

/*
    The GameState should have a game board (standard is 7x7),
    it should also save the turn
    and the scores of each player
*/

maplistlist(_,[]).
maplistlist(P, [H|T]) :- maplist(P,H), maplistlist(P, T).

length1(A, B) :- length(B, A).

isEqual(A, B) :- A = B.

initial_state(Size, GameState) :-
    length(GameBoard, Size),
    maplist(length1(Size), GameBoard),
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
    nth1(MoveX, GameBoard, Line),
    replace(MoveY, Line, '1', NewGameBoard).    

    
replace(I, L, E, K) :-
  nth0(I, L, _, R),
  nth0(I, K, E, R).
