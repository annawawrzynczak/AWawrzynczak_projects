function [x, l_literacji] = Metoda_Halleya(w, x, epsilon, max_l_literacji)

% Funkcja oszacowuje miejsca zerowe wielomianu za pomocą metody Halleya i
% algorytmu Hornera.

% w to wektor z współczynnikami wielomianu przy czym w(1) = an, w(n) = a0;
% x to punkt startowy; epsilon to dokładność;
% max_l_literacji to maksymalna liczba literacji dla x

% Wzór w metodzie Newtona: 
% x(k+1) = x(k) + ((2 * w(x(k)) * w'(x(k))) * 
% * 1/(2 * ((w'(x(k)))^2 - w(x(k)) * w"x(k))))),
% gdzie k = 0,1... oraz x(k) to kolejne punkty, 
% w których sprawdzane jest czy wartość wielomianu jest bliska 0

% punkt startowy to miejsce zerowe
if Horner(w,x) == 0
    l_literacji = 0;
    return
end

w_pochodna1 = pochodna_zn(w); % pierwsza pochodna wielomainu 
w_pochodna2 = pochodna_zn(w_pochodna1); % druga pochodna wielomianu
if ((Horner(w_pochodna1, x))^2 - Horner(w_pochodna2, x) * Horner(w, x)) == 0
    error("Podaj inny punkt startowy.")
end

iloraz = (2 * Horner(w, x) *  Horner(w_pochodna1, x)) / (2 * ((Horner(w_pochodna1, x))^2 - Horner(w_pochodna2, x) * Horner(w, x))); 
l_literacji = 0; % aktualna liczba literacji dla x

% warunki stop - 1) |x(k+1) - x(k)| > epsilon to jeden
% z warunków stop podanych w zapiskach;
% 2) ograniczenie na liczbę literacji po x
x1 = 0;
while (abs(x - x1) > epsilon) && (l_literacji < max_l_literacji)
    
    x1 = x;
    x = x - iloraz;

    if ((Horner(w_pochodna1, x))^2 - Horner(w_pochodna2, x) * Horner(w, x)) == 0
        return
    end

    iloraz = (2 * Horner(w, x) *  Horner(w_pochodna1, x)) / (2 * ((Horner(w_pochodna1, x))^2 - Horner(w_pochodna2, x) * Horner(w, x))); 

    l_literacji = l_literacji+1;
end

end