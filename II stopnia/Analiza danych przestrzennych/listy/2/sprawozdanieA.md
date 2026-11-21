# Sprawozdanie - Część A: GeoPandas

## Wstęp
Celem zadania było wczytanie i oczyszczenie danych pomiarowych pyłu PM2.5 z czujników na terenie Opola, przeprowadzenie analizy przestrzennej w bibliotece GeoPandas oraz odpowiedź na dwa pytania: które dzielnice Opola mają najgorsze powietrze oraz jak wygląda sytuacja w pobliżu szkół podstawowych.

## A1. Geometria i GeoDataFrame od zera

1. Utworzono obiekty geometryczne z biblioteki Shapely - punkt dla rynku w Opolu `Point(17.9226, 50.6681)` oraz poligon go obejmujący (w kolejności `x = lon`, `y = lat`).
2. Sprawdzono powierzchnię poligonu (`0.0001` w stopniach kwadratowych) oraz to, czy punkt zawiera się w poligonie (`square.contains(rynek)` zwróciło `True`).
3. Złożono z nich tabelę `GeoDataFrame` (`places`) z układem współrzędnych `EPSG:4326`, dla której potwierdzono typy geometrii `Point` i `Polygon`.

## A2. Wczytanie surowych danych

1. Wczytano surowy plik `dane/pm25_sensors.csv` za pomocą biblioteki pandas (145 wierszy i 5 kolumn).
2. Wstępna analiza (`describe()`, `isna().sum()`, `duplicated().sum()`) wykazała cztery problemy w danych:
   - 5 zduplikowanych wierszy,
   - 3 braki w kolumnie `lat` i 4 braki w `lon` (jeden brak pokrywał się z duplikatem),
   - minimalna wartość `lat` wynosiła ok. 17,87,
   - minimalna wartość `pm25` wynosiła -999.

**Pytanie:** Minimum `lat` wynosi ok. 17,9. Opole leży na szerokości ok. 50,7°. Skąd się wzięło 17,9?  
**Odpowiedź:** Wynikało to z zamiany miejscami wartości w kolumnach `lat` (ok. 50,7° N) i `lon` (ok. 17,9° E) w kilku wierszach.

## A3. Czyszczenie danych

1. Dane oczyszczono w czterech krokach:
   - usunięto duplikaty (liczba wierszy spadła ze 145 do 140),
   - usunięto wiersze z brakującymi współrzędnymi (spadek do 134 wierszy),
   - naprawiono 3 wiersze z zamienionymi współrzędnymi `lat` i `lon` (z użyciem `.to_numpy()`, żeby uniknąć ponownego dopasowania kolumn po nazwach przez pandas),
   - odrzucono 4 wiersze z kodem błędu `-999` (`pm25 < 0`), co dało ostatecznie 130 poprawnych wierszy.
2. Po czyszczeniu szerokość geograficzna `lat` mieści się w przedziale 50,62-50,77, a stężenie `pm25` w przedziale 9,2-35,3 µg/m³.

**Pytanie:** Wiersze z zamienionymi współrzędnymi naprawiliśmy, a wiersze z -999 usunęliśmy. Dlaczego potraktowaliśmy je inaczej?  
**Odpowiedź:** Wiersze z zamienionymi współrzędnymi zawierały prawdziwe odczyty zapisane w niewłaściwych kolumnach, natomiast wartość `-999` to kod awarii czujnika oznaczający brak pomiaru, którego nie da się odtworzyć.

## A4. Z tabeli do GeoDataFrame

1. Oczyszczoną tabelę zamieniono na obiekt `GeoDataFrame` (`sensors`) za pomocą `gpd.points_from_xy(df["lon"], df["lat"])` z układem `EPSG:4326`.
2. Sprawdzono typ geometrii (`Point`), układ współrzędnych (`EPSG:4326`) oraz zasięg przestrzenny (`total_bounds`: `[17.79, 50.62, 18.02, 50.77]`).
3. Wyświetlono mapę interaktywną `sensors.explore()`, która potwierdziła, że wszystkie punkty leżą na terenie Opola.

**Pytanie:** Co by się stało, gdyby zamienić argumenty: `points_from_xy(df["lat"], df["lon"])`? Gdzie wylądowały czujniki?  
**Odpowiedź:** Szerokość geograficzna (~50,7°) zostałaby potraktowana jako długość (E), a długość (~17,9°) jako szerokość (N), przez co punkty wylądowałyby w okolicach 17,9° N, 50,7° E, czyli na Półwyspie Arabskim (w Jemenie).

## A5. Układy współrzędnych

1. Obliczono odległość między dwoma pierwszymi czujnikami w układzie geograficznym `EPSG:4326`, uzyskując ok. 0,045 stopnia.
2. Po transformacji do polskiego układu metrycznego `EPSG:2180` (PUWG 1992) odległość między tymi samymi czujnikami wyniosła 4906 m, a współrzędne wyrażone są w metrach (wartości rzędu setek tysięcy).
3. Porównano odległość na trasie Gdańsk - Zakopane względem odległości geodezyjnej na elipsoidzie WGS84 (569,3 km):
   - w układzie `EPSG:2180` otrzymano 568,9 km (błąd -0,07%),
   - w układzie `EPSG:3857` (Web Mercator) otrzymano 922,8 km (błąd +62%, ponieważ odwzorowanie Mercatora rozciąga odległości o czynnik `1 / cos(szerokości)`).

## A6. Poligony: dzielnice Opola

1. Wczytano poligony dzielnic Opola z pliku `dane/opole_districts.geojson` (29 dzielnic w układzie `EPSG:4326`).
2. Przetransformowano warstwę do układu `EPSG:2180`, obliczono powierzchnię dzielnic w km² i wygenerowano mapę statyczną `districts.plot()`.
3. Całkowita powierzchnia miasta wyniosła 148,8 km²:
   - największa dzielnica: `Czarnowąsy` (ok. 14,1 km²),
   - najmniejsza dzielnica: `Borki` (ok. 0,66 km²).

**Pytanie:** Gdyby policzyć `.area` bez `to_crs`, jaki wynik byśmy dostali i dlaczego GeoPandas wyświetla wtedy ostrzeżenie?  
**Odpowiedź:** Obliczenie `.area` bezpośrednio w `EPSG:4326` zwróciłoby wynik w stopniach kwadratowych, a GeoPandas wyświetla wtedy ostrzeżenie, ponieważ stopnie nie mają stałej długości w metrach i nie nadają się do liczenia powierzchni.

## A7. Złączenie przestrzenne

1. Za pomocą `gpd.sjoin(sensors_m, districts[["name", "geometry"]], how="left", predicate="within")` przypisano każdy czujnik do dzielnicy, w której leży.
2. Po złączeniu wszystkie 130 czujników miało przypisaną dzielnicę (0 braków), natomiast w 3 dzielnicach nie było żadnego czujnika (`Bierkowice`, `Borki`, `Grotowice`).
3. Po pogrupowaniu wyników i odfiltrowaniu dzielnic z minimum 3 czujnikami (`sensor_count >= 3`) wyznaczono dzielnice o najgorszym powietrzu i zwizualizowano je na kartogramie:
   - `Stare Miasto`: 29,6 µg/m³ (3 czujniki),
   - `Śródmieście`: 26,8 µg/m³ (7 czujników),
   - `Zaodrze`: 22,5 µg/m³ (6 czujników).

**Pytanie:** Spróbuj `predicate="intersects"` zamiast `"within"`. Czy wynik się zmienił? Dla jakich danych by się zmienił?  
**Odpowiedź:** Wynik się nie zmienił dla tych danych, bo żaden czujnik nie leżał dokładnie na granicy poligonu. Różnica pojawiłaby się dla punktów leżących na samej krawędzi dzielnicy albo przy łączeniu linii lub poligonów przecinających granice.

## A8. Bufory

1. Wczytano lokalizacje 19 szkół podstawowych z pliku `dane/opole_schools.geojson`, przetransformowano je do układu `EPSG:2180` i utworzono wokół nich bufory o promieniu 500 m (`schools.buffer(500)`).
2. Po wykonaniu złączenia przestrzennego czujników z buforami oraz obliczeniu pokrycia powierzchni miasta (`union_all` i `intersection`) otrzymano następujące wyniki:
   - liczba wszystkich szkół: 19,
   - szkoły z czujnikiem w promieniu 500 m: 11,
   - średnie stężenie PM2.5 w pobliżu szkół: 22,3 µg/m³,
   - udział powierzchni miasta w zasięgu 500 m od szkoły: 9,5%.
3. Na koniec wyświetlono wspólną mapę złożoną z trzech warstw: granic dzielnic, buforów 500 m oraz czujników.

**Pytanie:** Zmień promień na 1500 m. Ile szkół ma teraz czujnik w pobliżu? Dlaczego bufor o promieniu 1500 m policzony w `EPSG:4326` (`buffer(1500)`) byłby katastrofą?  
**Odpowiedź:** Po zwiększeniu promienia bufora do 1500 m czujnik w pobliżu mają już wszystkie 19 szkół. Z kolei wywołanie `buffer(1500)` w układzie `EPSG:4326` utworzyłoby bufor o promieniu 1500 stopni (podczas gdy cała Ziemia ma 360°), więc każdy bufor objąłby całą kulę ziemską.

## A9. Zapis wyników

1. Wyniki zapisano do pliku GeoPackage `wyniki/pm25.gpkg` (dwie warstwy: `districts` oraz `sensors` w układzie `EPSG:2180`) oraz do pliku `wyniki/pm25_districts.geojson` (po konwersji do `EPSG:4326`).
2. Za pomocą `gpd.list_layers("wyniki/pm25.gpkg")` potwierdzono obecność obu warstw (`districts`, `sensors`), a kontrolne wczytanie warstwy `districts` zwróciło 29 wierszy w układzie `EPSG:2180`.
