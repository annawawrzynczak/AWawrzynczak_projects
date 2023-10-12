/* 
LABORATORIUM NR: 5
IMIE I NAZWISKO: Anna Wawrzyñczak
*/

/*zadanie 8****************************************************************;*/
/* Plik tekstowy L05z08 plik.txt ma 112 wierszy. Wczytaæ do zbioru sasowego te wiersze pliku L05z08 plik.txt, których numery znajduj¹ siê w pierwszym wierszu tego pliku. (Selekcja na poziomie wczytywania z pliku.) */

data L05z07_plik;
retain num_petli 1;
infile "C:\Users\Darek\Documents\sasy_lab\pd\pd5\L05z08_plik.txt" truncover N=112 line=num_line;

array row_num (1:12) (12*0);
array result(12);
if num_petli = 1 then do;
length value 8;
input #(1) value @;
	row_num[1] = value;
   do col=2 by 1 while(not(missing(value)));
     input value @;
	 if col < 13 then row_num[col] = value;
   end;
num_petli + 1;


do i = 1 to 12;
	row_index = row_num[i];
	input #(row_index) value @;
	result[1] = value;
   do col=2 by 1 while(not(missing(value)));
     input value @;
	 if col < 13 then result[col] = value;
   end;
	output;

end;
end;
drop value col num_petli i row_num: row_index;
run;


/* 
LABORATORIUM NR: 9
IMIE I NAZWISKO: Anna Wawrzynczak
*/

/*zadanie 5****************************************************************;*/

/* Wygenerowaæ do zbioru LICZBY 100 dowolnych obserwacji
numerycznych (patrz zbiór L09z05 LICZBY).
Napisaæ jeden DATA STEP, który stworzy
na podstawie zbioru LICZBY zbiór SUMA,
o jednej zmiennej suma i dziewiêædziesiêciu
piêciu obserwacjach. i-ta obserwacja w zbiorze SUMA ma 
byæ sum¹ obserwacji ze zbioru LICZBY,
o numerach {i, . . . , i + 5}.*/

proc print  data=work.liczby;run;

data SUMA;
set work.liczby point=point_liczby;

suma_x = x;
do i = 1 to 5;
point_loop = point_liczby + i;
set work.liczby(rename=(x=x_loop)) point=point_loop;
suma_x + x_loop;
end;
output;
point_liczby + 1;

if point_liczby = 96 then stop;

retain point_liczby 1;
drop i x point_liczby point_loop x_loop;
run;


/* 
LABORATORIUM NR: 10
IMIE I NAZWISKO: Anna Wawrzynczak
*/


/*zadanie 7****************************************************************;*/

/* Zdefiniowaæ format wypisuj¹cy ”s³ownie” liczby postaci 
m.n (m, n = 0, . . . , 9). 
Przyk³ad: liczba 2.8 ma
byæ sformatowana jako dwa i osiem dziesiatych,
liczba 6.1 ma byæ sformatowana jako szesc i jedna dziesiata.*/

data cyfry_polskie;
length cyfra $ 20;
array cyfry(12) $ 25 ('zero','jeden','dwa','trzy','cztery','piêæ','szeœæ','siedem','osiem','dziewiêæ','jedna','dwie'); 
array decimal(3) $ 25 ('dziesi¹ta','dziesi¹tych','dziesi¹te');
do i = 1 to 12;
cyfra = cyfry[i];
if i < 11 then liczba = i-1;
else call missing(liczba);
output;
end;
do i = 1 to 3;
cyfra = decimal[i];
call missing(liczba);
output;
end;
keep cyfra liczba;
run;

data numbers;
do i = 1 to 15;
num = round(rand('uniform',0,9.9),.1);
output;
end;
drop i;
run;
proc  sort  data=work.numbers overwrite nodupkey;
by num;run;

data ds_for_format_z7;
  length FMTNAME $ 7 TYPE $ 1 LABEL $ 75 cz_decimal $ 10;
  retain FMTNAME 'slownie' TYPE "N";
  do until(point_num = nobs +1);
  	
    set work.numbers nobs=nobs point=point_num;
	decimal = mod(num*10,10);
	unit = (num*10 - mod(num*10,10))/10;

	do i = 1 to 12;
	set work.cyfry_polskie point=i;
	if unit = liczba and i = 1 and decimal = 0 then do;
		LABEL = cyfra;START = num;output;leave;end;

	if liczba = unit and unit ^= 0 then do; pelna_nazwa = cyfra;end;
	if decimal = 1 and i = 11 then cz_decimal = cyfra; 
	if decimal = 2 and i = 12 then cz_decimal = cyfra; 
	if decimal = liczba and (decimal ^= 1 or decimal ^= 0 or decimal ^= 2) then cz_decimal = cyfra;
	end;
	if decimal ^= 0 and unit ^= 0 then do;
		if decimal = 1 then point = 13;
		if decimal = 3 or decimal = 4 or decimal = 2 then point =15;
		if 10 > decimal >= 5 then point=14;
		set work.cyfry_polskie point=point;
		LABEL = catx(' ', pelna_nazwa ,'i',cz_decimal,cyfra);
		START = num;output;
	end;
	if decimal ^= 0 and unit = 0 then do;
		if decimal = 1 then point = 13;
		if decimal = 3 or decimal = 4 or decimal = 2 then point =15;
		if 10 > decimal >= 5 then point=14;
		set work.cyfry_polskie point=point;
		LABEL = catx(' ',cz_decimal,cyfra);
		START = num;output;
	end;

	  point_num +1;
  end;

  call missing (START);
  LABEL = 'koniec';
  output;
stop;
keep LABEL TYPE FMTNAME START;
retain point_num 1;
run;

proc format LIBRARY = WORK CNTLIN = ds_for_format_z7;
run;




/* 
LABORATORIUM NR: 11
IMIE I NAZWISKO: Anna Wawrzynczak
*/

/*zadanie 7****************************************************************;*/
/* Napisaæ makro 
zale¿ne od dwóch parametrów NAZWY i ZNAKI, 
które z zadanego napisu NAZWY
wypisze do okienka Log wszystkie wyrazy, 
które nie zawieraj¹ znaków podanych 
w parametrze ZNAKI. Np.
NAPIS=Ala ma kota!, ZNAKI=! l, 
makro zwraca s³owo ”ma”. */


%macro wypisz_slowa(nazwy,znaki);
%let k=1;
%let znak=%scan(&znaki,&k," ");
%do %while(&znak ne );
	%let j=1;
	%let slowo=%scan(&nazwy,&j," ");	
	%do %while(&slowo ne );
		%znajdz_znak(&slowo,&znak);
		%let j=%sysevalf(&j+1);
		%let slowo=%scan(&nazwy,&j," ");	
	%end;
	%let k=%sysevalf(&k+1);
	%let znak=%scan(&znaki,&k," ");
%end;
run;
%mend wypisz_slowa;

%wypisz_slowa(ALA ma! ko!ta,! o m);

%macro znajdz_znak(slowo,znak);
 %let znak=%LOWCASE(&znak);
 %let i=1;                                              
 %let slowo_2=%LOWCASE(&slowo);
 %let litera_ze_slowa=%substr(&slowo_2,&i,1);
 %let wskaznik=0;
 %do %while(&litera_ze_slowa ne ); 
		%if &litera_ze_slowa=&znak %then %do;
		 %let wskaznik=1;
		%end;
	 %let i=%eval(&i+1);            
	%let litera_ze_slowa=%substr(&slowo_2,&i,1);
%end;
%if &wskaznik=0 %then %put ***....***slowo bez &znak : &slowo ***....***;


run;
%mend znajdz_znak;
%znajdz_znak(ala,l);


/*zadanie 9****************************************************************;*/
/*Napisaæ makro %komb(n, k), 
tworz¹ce dla danych n, k ? N 
zbiór sasowy kombinacje o k zmiennych
i (n k) obserwacjach. 
Wiersze zbioru kombinacje maj¹ zawieraæ 
k-elementowe kombinacje zbioru {1, . . . , n}. */

%macro liczba_obs(M,k);
%let odejmowanie_nk = %eval(&M-&k);
%obliczanie_silni(&M!);
%obliczanie_silni(&k!);
%obliczanie_silni(&odejmowanie_nk!);

data newton_z_&M;
set wynik_silnia_z_&M end=eof;
silnia_M = result;
set wynik_silnia_z_&k;
silnia_k = result;
set wynik_silnia_z_&odejmowanie_nk;
silnia_nk = result;
if eof then do;
newton_result = silnia_M/((silnia_k)*(silnia_nk));
output;
end;
keep newton_result;
run;
%mend liczba_obs;
%liczba_obs(6,2)

options minoperator;
%macro komb(S,p);
%liczba_obs(&S,&p);

data kombinacje;
set work.newton_z_&S end=eof;
koniec= newton_result;
if eof then do;

	array z(&p) (&p * 0);
	do i=1 to koniec;
	/* zerowanie arraya obserwacji*/
		do r=1 to dim(z);z[r]=0;end;
	do j=1 to dim(z);
	element = rand("INTEGER",1, &S);
		/* spr czy juz zostal wylosowany*/
		do while(element IN z);
		element = rand("INTEGER",1, &S);
		end;
	z[j] = element;
	end;
	output;
	end;

end;
keep z:;
run;
%mend komb;
%komb(6,4);


/* 
LABORATORIUM NR: 12
IMIE I NAZWISKO: Anna Wawrzynczak
*/
/*zadanie 6****************************************************************;*/
/* Za³ó¿my, ¿e podany jest zbiór z
o zmiennych tekstowych zbior i zmienna;
ka¿da obserwacja zawiera
nazwê zmiennej (zmienna), któr¹ nale¿y wyci¹æ ze zbioru
o nazwie zbior. Napisaæ i zaprezentowaæ dzia³anie
makra, które wczytuje zbiór z oraz odpowiednie zbiory 
w nim wymienione, wycina z nich odpowiednie zmienne
i skleja je jedna obok drugiej do pojedynczego zbioru
sasowego (mo¿na za³o¿yæ, ¿e wczytywane zbiory maj¹
unikalne, w skali globalnej, nazwy zmiennych).*/

%macro wytnij_zmienne(z);
proc transpose data=&z out=work.z_t(keep=COL:);
var zbior zmienna;

data _null_;
     set work.z_t end=eof;
	array COL(*) COL:;
	if _N_ =1 then do;
	zbiory=catx('@',of COL:);end;
	else do; zmienne=catx(' ', of COL:);end;
	put zmienne "**" zbiory;
   if eof then do;
call symputx("zmienne", zmienne, "L");
call symputx("zbiory", zbiory, "L");
call symputx("koniec", dim(COL), "L");
end;
retain zbiory zmienne;
run;

data result;
%do i = 1 %to &koniec;
  %let nazwa = %scan(&zbiory, &i,"@");
  set &nazwa;
%end;
keep &zmienne;
run;

%mend wytnij_zmienne;

%wytnij_zmienne(z);


/* 
LABORATORIUM NR: 13
IMIE I NAZWISKO: Anna Wawrzynczak
*/

/*zadanie 4****************************************************************;*/
/* Napisaæ i zaprezentowaæ dzia³anie makra
%ile(bib, grupa,wart), które w bibliotece bib
znajdzie wszystkie
zbiory sasowe zawieraj¹ce parê zmiennych 
numerycznych grupa i wart, a nastêpnie na ich 
podstawie wypisze do okienka Log tê wartoœæ 
(wartoœci) zmiennej grupa, która w znalezionych 
zbiorach wystêpuje z najwiêksz¹ liczb¹
ró¿nych wartoœci zmiennej wart. 
(Zak³adamy, ¿e w bibliotece bib mog¹ 
znajdowaæ siê zbiory sasowe, w których
zadana para zmiennych nie wystêpuje.)*/

%macro ile(bib, grupa,wart);
%let kropka=.;
%let bib=%upcase(&bib);

data _null_;
length sets $ 300;
set sashelp.vcolumn(where=(libname="&bib" and memtype="DATA" and (name="&grupa" or name="&wart"))) end=eof;
by notsorted memname;
/* to check if both variables are in a set */
if first.memname ^= last.memname;

if first.memname then do;
if _N_ = 1 then sets=memname;
else do;
sets=catx("#",sets,memname);
end;
end;
if eof then  call symputx("sets",sets,"L");

retain sets;
run;
%if %symexist(sets) %then %do; %put &sets;
%let i=1;
%let set=%scan(&sets,&i,#);
%do %while(&set ne );
	proc sql noprint;
	select &grupa into : result_&set. separated by " "
	from(
	select count( distinct &wart) as diff_wart,
	&grupa
	from &bib.&kropka.&set.
	group by &grupa)
	having diff_wart=max(diff_wart)
	;quit;
	%put grupy z najwieksza iloscia roznych wartosci w &set: &&result_&set.;

	%let i=%eval(&i + 1);
	%let set=%scan(&sets,&i,#);
%end;

%end;

%mend ile;
%ile(WORK,grupa,wart);



/*zadanie 7****************************************************************;*/
/* Zbiór Lab13z07 zawiera zmienne x i y 
oraz losow¹ liczbê obserwacji, których wartoœci
mog¹ byæ brakami danych. Napisaæ i zaprezentowaæ 
dzia³anie makra, które ustawia etykiety zmiennych 
w formie: ”Zmienna NAZWA ZMIENNEJ jest typu TYP,”
a dalej, w zale¿noœci od typu zmiennej:
n) jeœli jest numeryczna: 
”liczba brakujacych obserwacji to: NMISS, minimalna wartosc to: MIN, maksymalna
wartosc to MAX, srednia to: AV G”, 
precyzja wyœwietlania minimum i maksimum jest
taka jak w danych, a œredniej o rz¹d wielkoœci
wy¿sza (np. jeœli min=0.201, max=0.7,
to precyzja wyœwietlania to
trzy miejsca po przecinku dla minimum i maksimum,
a cztery dla œredniej),

/* a) rozw z makro */


%macro okresl_typ();
proc sql noprint;
select name into :var1-
from sashelp.vcolumn
where libname="PD13" and memtype="DATA" and memname=upcase("lab13z07")
;
%let novar = &SQLOBS.;
quit;
%put &var1 &novar;

data _null_;
set pd13.lab13z07;
%do i=1 %to &novar;
call symputx("typ_&&var&i.", vtype(&&var&i.),"L");
%end;
run;


%do i=1 %to &novar;
/* for numeric type:*/
	%if %eval(&&&&typ_&&var&i.=N) %then %do;
		proc sql noprint;
		select max_&&var&i., min_&&var&i., num_miss,
		avg_&&var&i.
		into :max_&&var&i., :min_&&var&i., :num_miss_&&var&i.,
		:avg_&&var&i.
		from(
		select MAX(&&var&i.) as max_&&var&i.,
		MIN(&&var&i.) as min_&&var&i.,
		NMISS(&&var&i.) as num_miss,
		MEAN(&&var&i.) as avg_&&var&i.
		from pd13.lab13z07)
		;quit; 
		%put dla &&var&i.: &&&&min_&&var&i., &&&&max_&&var&i. , &&&&num_miss_&&var&i., &&&&avg_&&var&i. ;
	%end;
/* for character type: */
	%if %eval(&&&&typ_&&var&i.=C) %then %do;
	proc sql noprint;
	select num_miss, max_len, min_len into :num_miss_&&var&i.,
	:max_len_&&var&i., :min_len_&&var&i.
	from(
	select &&var&i.
	, case when missing(&&var&i.) then .
		else length(&&var&i.)
		end as length
	,MAX(calculated length) as max_len,
	MIN(calculated length) as min_len,
	NMISS(&&var&i.) as num_miss
	from pd13.lab13z07)
	;quit;
	%put dla &&var&i.: &&&&min_len_&&var&i., &&&&max_len_&&var&i. , &&&&num_miss_&&var&i. ;

	%end;

%end;

data result;
set pd13.lab13z07;
%do i=1 %to &novar;
%if %eval(&&&&typ_&&var&i.=N) %then %do;
label &&var&i. = "&&var&i. jest typu &&&&typ_&&var&i. .Liczba brakujacych obserwacji to: &&&&num_miss_&&var&i., minimalna wartosc to: &&&&min_&&var&i.,
maksymalna wartosc to &&&&max_&&var&i.
, srednia to: &&&&avg_&&var&i.";
%end;
%if %eval(&&&&typ_&&var&i.=C) %then %do;
label &&var&i. = "&&var&i. jest typu &&&&typ_&&var&i. liczba brakujacych obserwacji to: &&&&num_miss_&&var&i. , dlugosc zmiennej to LENGTH, najkrotsza
nie pusta wartosc ma dlugosc &&&&min_len_&&var&i., najdluzsza wartosc ma dlugosc &&&&max_len_&&var&i.";
%end;
%end;
run;

%mend okresl_typ;

%okresl_typ();
proc contents data=work.result;
run;
/* b) z call execute */

%macro sql_numeric(var);

proc sql noprint;
select max, min, num_miss,
avg
into :max_&var., :min_&var., :num_miss_&var.,
:avg_&var.
from(
select MAX(&var.) as max,
MIN(&var.) as min,
NMISS(&var.) as num_miss,
MEAN(&var.) as avg
from pd13.lab13z07)
;quit; 
%put dla &var.: &&min_&var., &&max_&var. , &&num_miss_&var., &&avg_&var. ;

%mend sql_numeric;

%sql_numeric(x)

%macro sql_char(var);

	proc sql noprint;
	select num_miss, max_len, min_len into :num_miss_&var.,
	:max_len_&var., :min_len_&var.
	from(
	select &var.
	, case when missing(&var.) then .
		else length(&var.)
		end as length
	,MAX(calculated length) as max_len,
	MIN(calculated length) as min_len,
	NMISS(&var.) as num_miss
	from pd13.lab13z07)
	;quit;
	%put dla &var.: &&min_len_&var., &&max_len_&var. , &&num_miss_&var. ;

%mend sql_char;
%sql_char(y);

%macro okresl_typ_b();

data _null_;
set sashelp.vcolumn(where=(libname="PD13" and memname=upcase("lab13z07"))) end=eof;
call symputx("var"||put(pos,1.),name,"L");
pos +1;
if type="num" then do;
call symputx("typ_"||name,type,"L");
call execute('%sql_numeric('||name||')');
end;

if type="char" then do;
call symputx("typ_"||name,type,"L");
call execute('%sql_char('||strip(name)||')');
end;

if eof then call symputx("novar",varnum,"L");
keep name;
retain pos 1;
run;
%put &var1 &novar;

data result;
set pd13.lab13z07 end=eof;
if eof then do;
%do i=1 %to &novar;
	%if %eval(&&&&typ_&&var&i.=num) %then %do;
		call execute("%sql_numeric(&&var&i.)");
		label &&var&i. = "&&var&i. jest typu &&&&typ_&&var&i. .Liczba brakujacych obserwacji to: &&&&num_miss_&&var&i., minimalna wartosc to: &&&&min_&&var&i.,
		maksymalna wartosc to &&&&max_&&var&i.
		, srednia to: &&&&avg_&&var&i.";
	%end;
	%if %eval(&&&&typ_&&var&i.=char) %then %do;
		call execute("%sql_char(&&var&i.)");
		label &&var&i. = "&&var&i. jest typu &&&&typ_&&var&i. liczba brakujacych obserwacji to: &&&&num_miss_&&var&i. , dlugosc zmiennej to LENGTH, najkrotsza
		nie pusta wartosc ma dlugosc &&&&min_len_&&var&i., najdluzsza wartosc ma dlugosc &&&&max_len_&&var&i.";

	%end;
%end;
end;
run;

%mend okresl_typ_b;

%okresl_typ_b();
proc contents data=work.result;
run;






