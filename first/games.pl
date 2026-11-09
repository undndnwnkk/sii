:- encoding(utf8).
% =====================================================================
%  Лабораторная работа 1, часть 1.
%  База знаний "Видеоигры" на языке Prolog.
%
%  Что описано:
%    - игры, жанры и студии-разработчики (факты с одним аргументом);
%    - свойства игр: многопользовательская / открытый мир (факты с одним аргументом);
%    - связи "игра - жанр" и "игра - разработчик" (факты с двумя аргументами);
%    - правила, которые выводят новые знания из фактов.
%
%  Запуск:  swipl games.pl   (затем вводить запросы после "?-")
% =====================================================================


% ---------------------------------------------------------------------
%  ФАКТЫ С ОДНИМ АРГУМЕНТОМ (25 штук)
% ---------------------------------------------------------------------

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

% developer(Студия) - Студия (или человек) разрабатывает игры.
developer(cd_projekt_red).
developer(mojang).
developer(fromsoftware).
developer(ea_sports).
developer(alexey_pajitnov).
developer(id_software).

% multiplayer(Игра) - в Игре есть многопользовательский режим.
multiplayer(minecraft).
multiplayer(dark_souls).
multiplayer(fifa23).
multiplayer(doom).

% open_world(Игра) - Игра с открытым миром.
open_world(witcher3).
open_world(cyberpunk2077).
open_world(minecraft).


% ---------------------------------------------------------------------
%  ФАКТЫ С ДВУМЯ АРГУМЕНТАМИ (14 штук)
%  Они связывают игры с жанрами и разработчиками из фактов выше.
% ---------------------------------------------------------------------

% has_genre(Игра, Жанр) - Игра относится к Жанру.
has_genre(witcher3, rpg).
has_genre(cyberpunk2077, rpg).
has_genre(minecraft, sandbox).
has_genre(dark_souls, rpg).
has_genre(fifa23, sports).
has_genre(tetris, puzzle).
has_genre(doom, shooter).

% developed_by(Игра, Студия) - Игру разработала Студия.
developed_by(witcher3, cd_projekt_red).
developed_by(cyberpunk2077, cd_projekt_red).
developed_by(minecraft, mojang).
developed_by(dark_souls, fromsoftware).
developed_by(fifa23, ea_sports).
developed_by(tetris, alexey_pajitnov).
developed_by(doom, id_software).


% ---------------------------------------------------------------------
%  ПРАВИЛА (6 штук)
%  Обозначения: ","  - логическое И
%               ";"  - логическое ИЛИ
%               "\+" - логическое НЕ (отрицание как неудача)
% ---------------------------------------------------------------------

% 1. single_player(G) - игра только для одного игрока.
%    Игра, для которой НЕ известно, что она многопользовательская (НЕ).
single_player(G) :-
    game(G),
    \+ multiplayer(G).

% 2. open_world_rpg(G) - ролевая игра с открытым миром (И).
open_world_rpg(G) :-
    has_genre(G, rpg),
    open_world(G).

% 3. good_for_friends(G) - игра, в которую удобно играть с друзьями:
%    многопользовательская И (спорт ИЛИ шутер ИЛИ песочница).
good_for_friends(G) :-
    multiplayer(G),
    (   has_genre(G, sports)
    ;   has_genre(G, shooter)
    ;   has_genre(G, sandbox)
    ).

% 4. developer_genre(D, Genre) - студия D делала игры в жанре Genre.
%    Связывает два двухаргументных факта через общую игру G.
developer_genre(D, Genre) :-
    developed_by(G, D),
    has_genre(G, Genre).

% 5. same_developer(G1, G2) - две разные игры от одной студии.
same_developer(G1, G2) :-
    developed_by(G1, D),
    developed_by(G2, D),
    G1 \= G2.

% 6. multi_game_studio(D) - студия, выпустившая больше одной игры.
%    Использует правило 5. Условие G1 @< G2 (сравнение по алфавиту)
%    нужно, чтобы каждая пара игр учитывалась один раз.
multi_game_studio(D) :-
    same_developer(G1, G2),
    G1 @< G2,
    developed_by(G1, D).


% ---------------------------------------------------------------------
%  ПРИМЕРЫ ЗАПРОСОВ (вводить в swipl после загрузки файла)
%
%  Простые запросы к фактам:
%    ?- game(tetris).                     % true
%    ?- multiplayer(witcher3).            % false
%    ?- developed_by(doom, X).            % X = id_software
%
%  Запросы с переменными:
%    ?- game(X).                          % все игры (";" - следующий ответ)
%    ?- has_genre(X, rpg).                % все RPG
%    ?- developed_by(X, cd_projekt_red).  % игры CD Projekt Red
%
%  Запросы с логическими операторами И / ИЛИ / НЕ:
%    ?- multiplayer(X), has_genre(X, rpg).                     % И
%    ?- has_genre(X, puzzle) ; has_genre(X, shooter).          % ИЛИ
%    ?- game(X), \+ open_world(X).                             % НЕ
%    ?- open_world(X), \+ multiplayer(X), has_genre(X, rpg).   % всё вместе
%
%  Запросы, использующие правила:
%    ?- single_player(X).                 % witcher3, cyberpunk2077, tetris
%    ?- open_world_rpg(X).                % witcher3, cyberpunk2077
%    ?- good_for_friends(X).              % minecraft, fifa23, doom
%    ?- developer_genre(fromsoftware, G). % G = rpg
%    ?- same_developer(witcher3, X).      % X = cyberpunk2077
%    ?- multi_game_studio(D).             % D = cd_projekt_red
%    ?- findall(X, single_player(X), L), length(L, N).  % список и количество
% ---------------------------------------------------------------------
