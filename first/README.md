# Лабораторная работа 1 — объяснение с нуля

Тема: **база знаний «Видеоигры»** (Prolog) и **онтология** по ней (Protege).

Файлы в папке:

| Файл | Что это |
|---|---|
| `games.pl` | база знаний на Prolog (часть 1) |
| `games.owl` | онтология для Protege (часть 2) |
| `report.pdf` | отчёт по шаблону |
| `img/` | скриншоты SWI-Prolog и Protege (вставлены в отчёт) |
| `report.html` | исходник отчёта (оформлен по шаблону кафедры; PDF из него собран с номерами страниц и содержанием) |
| `README.md` | этот файл |

---

## Часть 1. Prolog

### 1.1. Что такое Prolog за одну минуту

В Prolog ты не пишешь *как* считать, а описываешь *что известно*:

- **Факт** — утверждение, которое всегда истинно: `game(tetris).` — «тетрис — это игра».
  Слово перед скобками — **предикат** (`game`), в скобках — **аргументы**.
  Имена с маленькой буквы (`tetris`) — константы (атомы).
- **Правило** — как вывести новое знание из имеющегося:
  `open_world_rpg(G) :- has_genre(G, rpg), open_world(G).`
  Читается: «G — RPG с открытым миром, **если** G имеет жанр rpg **и** G с открытым миром».
  `:-` = «если», `,` = И, `;` = ИЛИ, `\+` = НЕ.
- **Переменная** — имя с большой буквы (`G`, `X`). Prolog сам подбирает значения, при которых запрос истинен.
- **Запрос** — вопрос к базе после `?-`. Prolog отвечает `true/false` или выдаёт значения переменных.

### 1.2. Что лежит в `games.pl`

**Факты с одним аргументом (25 шт., требование ≥ 20):**

| Предикат | Смысл | Значения |
|---|---|---|
| `game/1` | это игра | witcher3, cyberpunk2077, minecraft, dark_souls, fifa23, tetris, doom (7) |
| `genre/1` | это жанр | rpg, sandbox, sports, puzzle, shooter (5) |
| `developer/1` | это разработчик | cd_projekt_red, mojang, fromsoftware, ea_sports, alexey_pajitnov, id_software (6) |
| `multiplayer/1` | есть мультиплеер | minecraft, dark_souls, fifa23, doom (4) |
| `open_world/1` | открытый мир | witcher3, cyberpunk2077, minecraft (3) |

(`game/1` значит «предикат game с 1 аргументом» — так принято обозначать в Prolog.)

**Факты с двумя аргументами (14 шт., требование 10–15)** — связывают объекты из фактов выше:

- `has_genre(Игра, Жанр)` — 7 фактов, например `has_genre(doom, shooter).`
- `developed_by(Игра, Студия)` — 7 фактов, например `developed_by(doom, id_software).`

**Правила (6 шт., требование 5–7):**

| Правило | Логика | Оператор |
|---|---|---|
| `single_player(G)` | игра, и НЕ мультиплеер | НЕ (`\+`) |
| `open_world_rpg(G)` | жанр rpg И открытый мир | И (`,`) |
| `good_for_friends(G)` | мультиплеер И (спорт ИЛИ шутер ИЛИ песочница) | И + ИЛИ (`;`) |
| `developer_genre(D, Genre)` | студия D сделала игру G, а у G жанр Genre | соединение двух фактов через общую переменную G |
| `same_developer(G1, G2)` | у двух игр одна студия, и G1 ≠ G2 | `\=` — «не равно» |
| `multi_game_studio(D)` | у студии есть пара разных игр (использует правило `same_developer`) | правило вызывает правило |

Пояснения к «скользким» местам (могут спросить на защите):

- **`\+ multiplayer(G)`** — «отрицание как неудача»: Prolog пытается доказать `multiplayer(G)`, не может — значит, считает это ложью. Это **предположение замкнутого мира**: всё, чего нет в базе, — ложь.
- **Почему в `single_player` сначала `game(G)`?** Чтобы G получила конкретное значение до отрицания. `\+` с несвязанной переменной работает некорректно.
- **`G1 @< G2`** в `multi_game_studio` — сравнение атомов по алфавиту. Без него пара (witcher3, cyberpunk2077) и пара (cyberpunk2077, witcher3) дали бы студию дважды.
- **`developer_genre(D, rpg)`** выдаст `cd_projekt_red` два раза — у неё две RPG. Это нормально: Prolog выдаёт ответ на каждый способ доказательства. Если надо без повторов — `setof(D, developer_genre(D, rpg), L).`

### 1.3. Как запустить

1. SWI-Prolog уже установлен (`C:\Program Files\swipl`). Если нет — скачать с swi-prolog.org.
2. Открыть терминал в папке с лабой и выполнить `swipl games.pl`
   (или запустить SWI-Prolog из меню Пуск → File → Consult → выбрать `games.pl`).
3. Появится приглашение `?-`. Вводишь запрос **с точкой в конце** и жмёшь Enter.
4. Если ответов несколько — Prolog покажет первый; нажми `;` (или пробел) для следующего, Enter — чтобы остановиться.
5. Выход: `halt.`

### 1.4. Запросы для демонстрации (все проверены)

```prolog
% --- простые запросы к фактам ---
?- game(tetris).                    % true
?- multiplayer(witcher3).           % false
?- developed_by(doom, X).           % X = id_software

% --- с переменными ---
?- game(X).                         % 7 игр по очереди
?- has_genre(X, rpg).               % witcher3, cyberpunk2077, dark_souls
?- developed_by(X, cd_projekt_red). % witcher3, cyberpunk2077

% --- И / ИЛИ / НЕ ---
?- multiplayer(X), has_genre(X, rpg).                    % dark_souls
?- has_genre(X, puzzle) ; has_genre(X, shooter).         % tetris, doom
?- game(X), \+ open_world(X).                            % dark_souls, fifa23, tetris, doom
?- open_world(X), \+ multiplayer(X), has_genre(X, rpg).  % witcher3, cyberpunk2077

% --- через правила ---
?- single_player(X).                % witcher3, cyberpunk2077, tetris
?- open_world_rpg(X).               % witcher3, cyberpunk2077
?- good_for_friends(X).             % minecraft, fifa23, doom
?- developer_genre(fromsoftware, G).% G = rpg
?- same_developer(witcher3, X).     % X = cyberpunk2077
?- multi_game_studio(D).            % D = cd_projekt_red
?- findall(X, single_player(X), L), length(L, N).  % L = [witcher3,cyberpunk2077,tetris], N = 3
```

---

## Часть 2. Онтология в Protege

### 2.1. Что такое онтология за одну минуту

Онтология (язык OWL) описывает предметную область через:

- **Классы** (Classes) — множества объектов: `Game`, `Genre`, `Developer`. Классы образуют **иерархию** (подклассы): `MultiplayerGame ⊂ Game`.
- **Индивиды** (Individuals) — конкретные объекты: `witcher3`, `rpg`, `mojang`.
- **Объектные свойства** (Object properties) — связи между индивидами: `witcher3 hasGenre rpg`.
- **Ризонер** (reasoner, у нас HermiT) — «движок вывода», аналог выполнения правил в Prolog: сам вычисляет, в какие классы попадают индивиды, и достраивает связи.

### 2.2. Как Prolog перешёл в онтологию

| Prolog | Онтология (OWL) |
|---|---|
| `game/1`, `genre/1`, `developer/1` | классы `Game`, `Genre`, `Developer` (объявлены непересекающимися — Disjoint) |
| `multiplayer/1`, `open_world/1` | подклассы `MultiplayerGame`, `OpenWorldGame` класса `Game` |
| константы `witcher3`, `rpg`, `mojang`… | индивиды (Individuals) |
| `has_genre/2` | объектное свойство `hasGenre` (Domain: Game, Range: Genre) |
| `developed_by/2` | свойство `developedBy` (Game → Developer) + обратное ему `developerOf` |
| правило `single_player` | класс `SinglePlayerGame ≡ Game and not MultiplayerGame` |
| правило `open_world_rpg` | класс `OpenWorldRPG ≡ OpenWorldGame and (hasGenre value rpg)` |
| правило `good_for_friends` | класс `GameForFriends ≡ MultiplayerGame and (hasGenre some {sports, shooter, sandbox})` |
| правило `developer_genre` | свойство `worksInGenre`, заданное цепочкой `developerOf o hasGenre` |
| правило `same_developer` | свойство `sameDeveloperAs`, цепочка `developedBy o developerOf` |
| правило `multi_game_studio` | класс `MultiGameStudio ≡ Developer and (developerOf min 2 Game)` |

Знак `≡` (Equivalent To) значит «определение»: всё, что подходит под условие, ризонер **сам** отнесёт к классу. Именно так в онтологии работают «правила».

**Цепочка свойств** (property chain) `developerOf o hasGenre` читается: «если студия — разработчик игры, а у игры есть жанр, то студия работает в этом жанре». Это прямой аналог правила `developer_genre(D, Genre) :- developed_by(G, D), has_genre(G, Genre).`

### 2.3. Две важные тонкости (на защите любят спрашивать)

1. **Открытый мир vs замкнутый мир.** Prolog считает ложным всё, чего нет в базе. OWL так не делает: «не сказано, что мультиплеер» ≠ «не мультиплеер». Поэтому, чтобы `SinglePlayerGame` заработал, в онтологии список многопользовательских игр **закрыт явно**: `MultiplayerGame ≡ {minecraft, dark_souls, fifa23, doom}` (вкладка Equivalent To у класса). Для сравнения: запрос `Game and not OpenWorldGame` в Protege вернёт **пусто** (список игр с открытым миром не закрыт), а такой же запрос в Prolog вернёт 4 игры. Это наглядная разница между подходами.
2. **Все индивиды различны (AllDifferent).** OWL не предполагает, что разные имена — разные объекты (`witcher3` и `cyberpunk2077` теоретически могут быть одним и тем же). Без этого ризонер не может посчитать «min 2 игры» для `MultiGameStudio`. Поэтому в онтологии есть аксиома Different Individuals (в Protege: у любого индивида раздел «Different Individuals»).

### 2.4. Что тыкать в Protege (пошагово)

**Запуск и открытие**

1. Запустить `C:\Soft\Protege-5.6.9\Protege.exe` (или `run.bat`).
2. `File → Open...` → выбрать `games.owl`.
   (Если при старте выскочит окно *Automatic Update* со списком плагинов — жми **Not now**.)
3. **Один раз:** меню `View → Render by entity IRI short name (Id)`. Тогда имена отображаются как `Game`, `witcher3` (без `:` спереди), и DL-запросы из таблицы ниже вводятся ровно так, как написано. На этом компьютере я это уже переключил, настройка запоминается.

**Показать классы и иерархию**

3a. Вкладка **Entities** → подвкладка **Classes**. Видно дерево: `owl:Thing → Game → MultiplayerGame, OpenWorldGame`, а также `Genre`, `Developer` и классы-правила (`SinglePlayerGame`, `OpenWorldRPG`, `GameForFriends`, `MultiGameStudio`) — пока они лежат прямо под `owl:Thing`.
4. Кликнуть `OpenWorldRPG` → справа в **Description → Equivalent To** видно определение `OpenWorldGame and (hasGenre value rpg)`. В **Annotations** — комментарий, какому Prolog-правилу он соответствует.

**Показать свойства**

5. Подвкладка **Object properties**: `hasGenre`, `developedBy`, `developerOf`, `worksInGenre`, `sameDeveloperAs`. Кликнуть `developedBy` → видно Domain (Game), Range (Developer), Inverse Of (developerOf). Кликнуть `worksInGenre` → в **SuperProperty Of (Chain)** видна цепочка `developerOf o hasGenre`.

**Показать индивиды (факты)**

6. Подвкладка **Individuals** (или вкладка Individuals by class) → кликнуть `witcher3`: Types — `Game`, `OpenWorldGame`; Property assertions — `hasGenre rpg`, `developedBy cd_projekt_red`. Это и есть Prolog-факты.

**Запустить ризонер (вывод по «правилам»)**

7. Меню **Reasoner → HermiT** (поставить галочку), затем **Reasoner → Start reasoner**.
8. Снова во вкладке Classes: дерево перестроилось (выведенные связи подсвечены жёлтым): `SinglePlayerGame` и `OpenWorldRPG` ушли под `Game`/`OpenWorldGame`, `GameForFriends` — под `MultiplayerGame`, `MultiGameStudio` — под `Developer`.
9. Кликнуть индивида `witcher3` → в Types появились выведенные (жёлтые) `SinglePlayerGame`, `OpenWorldRPG`; в Property assertions — `sameDeveloperAs cyberpunk2077`. У `cd_projekt_red` появится `worksInGenre rpg` и тип `MultiGameStudio`.
   (Чтобы жёлтый вывод был виден — справа сверху у панели должна стоять галочка «Show inferences», обычно включено по умолчанию.)

**Запросы (DL Query)**

10. Вкладка **DL Query** (если её нет: `Window → Tabs → DL Query`).
11. Ввести запрос, справа поставить галочку **Instances**, нажать **Execute**. Ризонер должен быть запущен.

| DL Query | Результат | Аналог в Prolog |
|---|---|---|
| `Game` | 7 игр | `game(X).` |
| `hasGenre value rpg` | cyberpunk2077, dark_souls, witcher3 | `has_genre(X, rpg).` |
| `developedBy value cd_projekt_red` | cyberpunk2077, witcher3 | `developed_by(X, cd_projekt_red).` |
| `MultiplayerGame and hasGenre value rpg` | dark_souls | `multiplayer(X), has_genre(X, rpg).` |
| `hasGenre value puzzle or hasGenre value shooter` | doom, tetris | `has_genre(X,puzzle) ; has_genre(X,shooter).` |
| `SinglePlayerGame` (или `Game and not MultiplayerGame`) | cyberpunk2077, tetris, witcher3 | `single_player(X).` |
| `OpenWorldRPG` | cyberpunk2077, witcher3 | `open_world_rpg(X).` |
| `GameForFriends` | doom, fifa23, minecraft | `good_for_friends(X).` |
| `Developer and worksInGenre value rpg` | cd_projekt_red, fromsoftware | `developer_genre(D, rpg).` |
| `MultiGameStudio` | cd_projekt_red | `multi_game_studio(D).` |
| `sameDeveloperAs value witcher3` | cyberpunk2077, witcher3 (*) | `same_developer(X, witcher3).` |
| `Game and not OpenWorldGame` | **пусто** (открытый мир!) | `game(X), \+ open_world(X).` → 4 игры |

(*) В OWL нельзя написать «G1 ≠ G2» внутри цепочки, поэтому игра «от той же студии, что и она сама». В Prolog это отсекает `G1 \= G2`.

**Визуализация**

12. `Window → Tabs → OntoGraf` (появится вкладка OntoGraf, перейти на неё).
    - **Весь граф:** в поле *Search* ввести `.*`, в выпадающем списке справа выбрать `regexp`, нажать **Search** (найдётся 29 сущностей), затем на панели инструментов нажать кнопку раскладки «Spring» (вторая кнопка во второй группе, иконка-снежинка).
    - **Граф одной игры (нагляднее):** нажать **Clear**, ввести `witcher3`, **Search**. Появится witcher3 со связями. **Двойной клик** по узлу `cd_projekt_red` и по `rpg` раскрывает их соседей (появятся cyberpunk2077, dark_souls). Затем кнопка раскладки «Radial» (третья кнопка в той же группе).
    - Как читать граф: кружки — классы, ромбы — индивиды. Фиолетовые сплошные стрелки — «индивид принадлежит классу», синие — «подкласс», **оранжевые пунктирные — hasGenre**, **жёлтые пунктирные — developedBy**. Если навести мышь на ребро, всплывёт его название.
    - Кнопку «развернуть панель» (квадратик в правом верхнем углу панели OntoGraf) лучше не нажимать: в этой версии OntoGraf при откреплении панели падает с ошибкой ClassCastException (если случилось — просто закрой всплывшее окно крестиком).
13. Альтернатива: `Window → Tabs → OWLViz` — рисует только иерархию классов (может просить Graphviz; если ругается — используй OntoGraf).

**(Необязательно) SPARQL**

14. `Window → Tabs → SPARQL Query` и запрос:

```sparql
PREFIX : <http://www.semanticweb.org/lab1/games#>
SELECT ?game ?dev WHERE { ?game :hasGenre :rpg . ?game :developedBy ?dev . }
```

SPARQL работает только с явными фактами (без ризонера), поэтому для «правил» используем DL Query.

### 2.5. Если хочешь показать, что умеешь делать руками

Пример: добавить новую игру прямо в Protege.
Individuals → кнопка «+» (Add individual) → имя `portal2` → Types «+» → `Game` → Property assertions «+» у Object property assertions → `hasGenre` `puzzle`. Затем **Reasoner → Synchronize reasoner** — и `portal2` появится в DL Query `hasGenre value puzzle`.
(Важно: в `SinglePlayerGame` она **не** попадёт, пока не добавить её в список `Different Individuals` — это та же история про открытый мир и уникальность имён.)

Сохранение: `File → Save` (формат RDF/XML по умолчанию).

---

## Шпаргалка ответов на вероятные вопросы

- **Чем факт отличается от правила?** Факт истинен безусловно, правило — при выполнении условий в теле (после `:-`).
- **Как Prolog ищет ответ?** Сопоставлением с образцом (унификацией) и перебором с возвратом (backtracking): пробует факты/правила сверху вниз, при неудаче откатывается и пробует следующий вариант.
- **Что такое `\+`?** Отрицание как неудача: истинно, если доказать цель не удалось.
- **Чем онтология отличается от БЗ на Prolog?** Онтология — стандартизованное (W3C OWL) описание понятий с иерархией классов и строгой логикой (дескрипционные логики), рассчитанное на обмен знаниями и автоматическую проверку непротиворечивости; работает в открытом мире. Prolog — язык программирования с замкнутым миром, гибкими правилами и произвольными вычислениями.
- **Что делает ризонер?** Проверяет непротиворечивость, строит выведенную иерархию классов, относит индивидов к классам по определениям, достраивает свойства (обратные, цепочки).
- **Что такое Domain/Range?** Domain — к какому классу относится субъект свойства, Range — объект. `hasGenre`: из Game в Genre.
