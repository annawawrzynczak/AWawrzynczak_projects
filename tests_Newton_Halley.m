% Porównanie metody Newtona i Halleya

% losowanie a, b, c, d, m, n
a = randi([0,20], 1, 1);
b = a + (randi([0,20], 1, 1));
c = randi([0,25], 1, 1);
d = c + (randi([0,15], 1, 1));
n = randi([1, 20], 1, 1);
m = randi([1, 20], 1, 1);

% obliczanie h1, h2
h1 = (b-a)/n;
h2 = (c-d)/m;

x = zeros(1, n+1); % wektor z częściami rzeczywistymi
y = zeros(1, m+1); % wektor z częściami urojonymi
w = randi([-20, 20], 1, n+m); % współczynniki wielomianu

for i = 1:n+1
    x(i) = a + (i-1) * h1;
end

for j = 1:m+1
    y(j) = c + (j-1) * h2;
end

punkty_startowe = zeros(n+1, m+1);
for i = 1:n+1
    for j = 1:m+1
        punkty_startowe(i, j) = x(i) + y(j) * 1i;
    end
end

kmax = 200; % maksymalna liczba iteracji w metodach
epsilon = 10^-6;

A_Newton = zeros(n+1, m+1); % macierz z ilością iteracji 
% potrzebnymi do oszacowania miejsca zerowego metodą Newtona
A_Newton2 = zeros(n+1, m+1); % macierz z ilością iteracji 
% potrzebnymi do oszacowania miejsca zerowego metodą pierwszą Newtona
time_Newton1 = zeros(1, m+1); % czas działania zwykłej metody Newtona
time_NewtonC = zeros(1, m+1); %  czas działania ulepszonej metody Newtona

for i = 1:n+1
    for j = 1:m+1
        tic
        [~, A_Newton(i, j)] = Metoda_NewtonaC(w, punkty_startowe(i, j), epsilon, kmax);
        time_NewtonC(j) = toc;
        tic
        [~, A_Newton2(i, j)] = Metoda_Newtona(w, punkty_startowe(i, j), epsilon, kmax); 
        time_Newton1(j) = toc;
    end
end

A_Halley = zeros(n+1, m+1); % macierz z ilością iteracji 
% potrzebnymi do oszacowania miejsca zerowego metodą Halleya
A_Halley2 = zeros(n+1, m+1);% macierz z ilością iteracji 
% potrzebnymi do oszacowania miejsca zerowego metodą pierwszą Halleya
time_Halley1 = zeros(1, m+1); % czas działania zwykłej metody Halleya
time_HalleyC = zeros(1, m+1); %  czas działania ulepszonej metody Halleya

for i = 1:n+1
    for j = 1:m+1
        tic
        [~, A_Halley(i, j)] = Metoda_HalleyaC(w, punkty_startowe(i, j), epsilon, kmax);
        time_HalleyC(i) = toc;
        tic
        [~, A_Halley2(i, j)] = Metoda_Halleya(w, punkty_startowe(i, j), epsilon, kmax); 
        time_Halley1(i) = toc;
    end
end

% wykresy: siatka punktów oraz dwa wykresy pokazujące liczbę iteracji w obu
% "ulepszonych" metodach
figure,
subplot(2, 2, [3 4])
hold on
for i = 1:n+1
    for j = 1:m+1
        plot(x(i),y(j), '.', 'markersize', 8);
    end
end
hold off
title("Siatka wylosowanych punktów "); xlabel("Oś rzeczywista"); ylabel("Oś urojona")

subplot(2, 2, 1)
imagesc(A_Newton); colorbar; title("Ilość iteracji w metodzie NewtonaC");
subplot(2, 2, 2)
imagesc(A_Halley); colorbar; title("Ilość iteracji w metodzie HalleyaC")

% wykres porównujący dwie pierwsze metody 
figure,
subplot(2, 2, 1)
imagesc(A_Newton2); colorbar; title("Ilość iteracji w metodzie Newtona");
subplot(2, 2, 2)
imagesc(A_Halley2); colorbar; title("Ilość iteracji w metodzie Halleya")



% porównanie działania i błędów generowanych przez zwykłą i ulepszoną
% metodę Newtona

% przykładowy wielomian, który będzie miał pierwiastki o niezerowej
% urojonej części
% Zatem wielomian będzie miał jedynie parzyste potęgi i dodatni wyraz wolny

w1 = (randi([0,20], 1, 2*(m+n))); 
for i = 1:length(w1)
    if mod(i, 2) ~= 0
        w1(i) = 0; % warunek na parzyste potęgi
    end
end

punkty_startowe2 = randi([1,30], 1, m+n)*30; % punkty startowe
wyniki_NewtonC = zeros(2, m+n); % ta macierz będzie zawierać przybliżone
% miejsca zerowe w pierwszym wierszu i ilość literacji dla ulepszonej
% metody Newtona
wyniki_Newton = zeros(2, m+n); % ta macierz będzie zawierać przybliżone
% miejsca zerowe w pierwszym wierszu i ilość literacji dla zwykłej
% metody Newtona
blad_przyblizenia_Newton = zeros(2, m+n); %pierwszy wiersz przedstawia błąd 
% przybliżenia dla zwykłej metody, drugi dla ulepszonej

% analogiczne wektory dla metody Halleya
wyniki_HalleyC = zeros(2, m+n);
wyniki_Halley = zeros(2, m+n);
blad_przyblizenia_Halley = zeros(2, m+n);

for j = 1:length(punkty_startowe2)
    [wyniki_NewtonC(1, j), wyniki_NewtonC(2, j)] = Metoda_NewtonaC(w1, punkty_startowe2(j), epsilon, kmax);
    [wyniki_Newton(1, j), wyniki_Newton(2, j)] = Metoda_Newtona(w1, punkty_startowe2(j), epsilon, kmax);
    blad_przyblizenia_Newton(1, j) = abs(Horner(w1, wyniki_Newton(1, j)));
    blad_przyblizenia_Newton(2, j) = abs(Horner(w1, wyniki_NewtonC(1, j)));
    [wyniki_HalleyC(1, j), wyniki_HalleyC(2, j)] = Metoda_HalleyaC(w1, punkty_startowe2(j), epsilon, kmax);
    [wyniki_Halley(1, j), wyniki_Halley(2, j)] = Metoda_Halleya(w1, punkty_startowe2(j), epsilon, kmax);
    blad_przyblizenia_Halley(1, j) = abs(Horner(w1, wyniki_Halley(1, j)));
    blad_przyblizenia_Halley(2, j) = abs(Horner(w1, wyniki_HalleyC(1, j)));
end

% wykresy 
% wykres przedstawiający różnce w czasie działania metod Newtona
figure,
subplot(2,2,[1,2])
plot(time_Newton1,"o");
hold on
plot(time_NewtonC,"ro");
title("Porównanie czasu działania zwykłej metody Newtona i 'ulepszonej'")
legend("Czas dla zwykłego Newtona","Czas dla ulepszonego Newtona");
xlabel(" ");ylabel("Czas");
hold off

% wykres przedstawiający różnce w czasie działania metod Halleya
subplot(2,2,[3,4])
plot(log(time_Halley1),"o");
hold on
plot(log(time_HalleyC),"ro");
title("Porównanie czasu działania zwykłej metody Halleya i 'ulepszonej' w skali logarytmicznej")
legend("Czas dla zwykłego Halleya","Czas dla ulepszonego Halleya");
xlabel(" ");ylabel("Czas");
hold off

% wykres przedstawiający błąd przybliżenia w przypadku obu metod Netwona
figure,
plot(log10(blad_przyblizenia_Newton(1,:)),"o");
hold on
plot(log10(blad_przyblizenia_Newton(2,:)),"ro");
ylim([min(log10(blad_przyblizenia_Newton(2,:))) max(log10(blad_przyblizenia_Newton(1,:)))]);
title("Porównanie błędu przybliżenia z obu metod Newtona w skali logarytmicznej");
legend("Błąd dla zwykłej metody","Błąd dla ulepszonej metody");
xlabel(" ");ylabel("Wartość błędu");
hold off

% wykres przedstawiający błąd przybliżenia w przypadku obu metod Halleya
figure,
plot(log10(blad_przyblizenia_Halley(1,:)),"o");
hold on
plot(log10(blad_przyblizenia_Halley(2,:)),"ro");
ylim([min(log10(blad_przyblizenia_Halley(2,:))) max(log10(blad_przyblizenia_Halley(1,:)))]);
title("Porównanie błędu przybliżenia z obu metod Halleya w skali logarytmicznej");
legend("Błąd dla zwykłej metody","Błąd dla ulepszonej metody");
xlabel(" ");ylabel("Wartość błędu");
hold off



