:- encoding(utf8).
%  Запуск:  swipl games.pl   (затем вводить запросы после "?-")


%  ФАКТЫ С ОДНИМ АРГУМЕНТОМ (25 штук)

% game(Игра) - Игра является видеоигрой.
game(witcher3).
game(cyberpunk2077).
game(minecraft).
game(dark_souls).
game(fifa23).
game(tetris).
game(doom).

% genre(Жанр) - Жанр является игровым жанром.
genre(rpg).        % ролевая игра
genre(sandbox).    % песочница
genre(sports).     % спортивный симулятор
genre(puzzle).     % головоломка
genre(shooter).    % шутер

% country(Страна) - Страна, в которой создаются игры.
country(poland).
country(sweden).
country(japan).
country(canada).
country(ussr).
country(usa).

% has_story(Игра) - в Игре есть сюжетная кампания.
has_story(witcher3).
has_story(cyberpunk2077).
has_story(dark_souls).
has_story(doom).

% open_world(Игра) - Игра с открытым миром.
open_world(witcher3).
open_world(cyberpunk2077).
open_world(minecraft).


%  ФАКТЫ С ДВУМЯ АРГУМЕНТАМИ (14 штук)

% has_genre(Игра, Жанр) - Игра относится к Жанру.
has_genre(witcher3, rpg).
has_genre(cyberpunk2077, rpg).
has_genre(minecraft, sandbox).
has_genre(dark_souls, rpg).
has_genre(fifa23, sports).
has_genre(tetris, puzzle).
has_genre(doom, shooter).

% made_in(Игра, Страна) - Игра создана в Стране.
made_in(witcher3, poland).
made_in(cyberpunk2077, poland).
made_in(minecraft, sweden).
made_in(dark_souls, japan).
made_in(fifa23, canada).
made_in(tetris, ussr).
made_in(doom, usa).


%  ПРАВИЛА (6 штук)

% 1. no_story(G) - игра без сюжета.
%    Игра, для которой НЕ известно, что в ней есть сюжет (НЕ).
no_story(G) :-
    game(G),
    \+ has_story(G).

% 2. open_world_rpg(G) - ролевая игра с открытым миром (И).
open_world_rpg(G) :-
    has_genre(G, rpg),
    open_world(G).

% 3. casual_game(G) - игра "чтобы расслабиться":
%    без сюжета (правило 1) И (головоломка ИЛИ песочница).
casual_game(G) :-
    no_story(G),
    (   has_genre(G, puzzle)
    ;   has_genre(G, sandbox)
    ).

% 4. country_genre(C, Genre) - в стране C делают игры в жанре Genre.
%    Связывает два двухаргументных факта через общую игру G.
country_genre(C, Genre) :-
    made_in(G, C),
    has_genre(G, Genre).

% 5. same_country(G1, G2) - две разные игры из одной страны.
same_country(G1, G2) :-
    made_in(G1, C),
    made_in(G2, C),
    G1 \= G2.

% 6. game_dev_country(C) - страна, в которой создано больше одной игры.
%    Использует правило 5. Условие G1 @< G2 (сравнение по алфавиту)
%    нужно, чтобы каждая пара игр учитывалась один раз.
game_dev_country(C) :-
    same_country(G1, G2),
    G1 @< G2,
    made_in(G1, C).


% ---------------------------------------------------------------------
%  ПРИМЕРЫ ЗАПРОСОВ (вводить в swipl после загрузки файла)
%
%  Простые запросы к фактам:
%    ?- game(tetris).                     % true
%    ?- has_story(minecraft).             % false
%    ?- made_in(doom, X).                 % X = usa
%
%  Запросы с переменными:
%    ?- game(X).                          % все игры (";" - следующий ответ)
%    ?- has_genre(X, rpg).                % все RPG
%    ?- made_in(X, poland).               % польские игры
%
%  Запросы с логическими операторами И / ИЛИ / НЕ:
%    ?- has_story(X), has_genre(X, rpg).                       % И
%    ?- has_genre(X, puzzle) ; has_genre(X, shooter).          % ИЛИ
%    ?- game(X), \+ open_world(X).                             % НЕ
%    ?- open_world(X), \+ has_story(X).                        % И + НЕ
%
%  Запросы, использующие правила:
%    ?- no_story(X).                      % minecraft, fifa23, tetris
%    ?- open_world_rpg(X).                % witcher3, cyberpunk2077
%    ?- casual_game(X).                   % minecraft, tetris
%    ?- country_genre(japan, G).          % G = rpg
%    ?- same_country(witcher3, X).        % X = cyberpunk2077
%    ?- game_dev_country(C).              % C = poland
%    ?- findall(X, no_story(X), L), length(L, N).  % список и количество
