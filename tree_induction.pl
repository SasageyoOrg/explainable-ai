/*
programma per apprendere inducendo Alberi di Decisione testandone
l' efficacia
*/


%:- ensure_loaded(stroke_dataset_tot).
:- ensure_loaded(aa_stroke_dataset).
:- ensure_loaded(aa_training_set).
:- ensure_loaded(aa_test_set).
:- ensure_loaded(classify).
:- ensure_loaded(writes).

:- dynamic alb/1.

induce_albero( Albero ) :-
	findall( e(Classe,Oggetto), e(Classe,  Oggetto), Esempi),
	findall( Att,a(Att,_), Attributi),
	induce_albero( Attributi, Esempi, Albero),
	mostra( Albero ),
	txt( Albero ),
	assert(alb(Albero)),
	stampa(Albero).


/*
induce_albero( +Attributi, +Esempi, -Albero):
l'Albero indotto dipende da questi tre casi:
(1) Albero = null: l'insieme degli esempi è vuoto
(2) Albero = l(Classe): tutti gli esempi sono della stessa classe
(3) Albero = t(Attributo, [Val1:SubAlb1, Val2:SubAlb2, ...]):
    gli esempi appartengono a più di una classe
    Attributo è la radice dell'albero
    Val1, Val2, ... sono i possibili valori di Attributo
    SubAlb1, SubAlb2,... sono i corrispondenti sottoalberi di
    decisione.
(4) Albero = l(Classi): non abbiamo Attributi utili per
    discriminare ulteriormente
*/
induce_albero( _, [], null ) :- !. % (1)

induce_albero( _, [e(Classe,_)|Esempi], l(Classe)) :-           % (2)
	\+ ( member(e(ClassX,_),Esempi), ClassX \== Classe ), !.	% no esempi di altre classi (OK!!)

induce_albero( Attributi, Esempi, t(Attributo,SAlberi) ) :-	    % (3)
	sceglie_attributo( Attributi, Esempi, Attributo), !,	    % implementa la politica di scelta
	%sceglie_attributo( Attributi, Esempi, 0, Attributo), !,	
	del( Attributo, Attributi, Rimanenti ),					    % elimina Attributo scelto
	a( Attributo, Valori ),					 				    % ne preleva i valori
	induce_alberi( Attributo, Valori, Rimanenti, Esempi, SAlberi).

%finiti gli attributi utili (KO!!)
induce_albero( _, Esempi, l(ClasseDominante)) :-
	findall( Classe, member(e(Classe,_), Esempi), Classi),
	verify_occurrences(Classi, ClasseDominante).

verify_occurrences(Classi, X):-
	(occurrences(Classi, sick, healthy)) -> 
	(calc_classe_dominante(true, Classi, X));
	(calc_classe_dominante(false, Classi, X)).

calc_classe_dominante(true, _, [sick, healthy]).
calc_classe_dominante(false, Classi, ClasseDominante):- 
	calc_prob_classi(Classi, ClasseDominante).

% ################## Utility ##################
% versione con Occorrenze come output
%calc_prob_classi(L, N, X) :-
%   aggregate(max(N1,X1), conteggio_elementi(X1,N1,L), max(N,X)).

% ricava l'istanza con il maggior numero di occorrenze di X in una lista 
calc_prob_classi(List, X) :-
    aggregate(max(N1, X1), conteggio_elementi(X1, N1, List), max(N1, X)).
% conteggio del numero di istanze Count di X in una lista 
conteggio_elementi(X, Count, List) :-
    aggregate(count, member(X, List), Count).

occurrences([],_A,_B,N,N).
occurrences([H|T],A,B,N0,M0) :-
	elem_x_count(H,A,N1,N0),
	elem_x_count(H,B,M1,M0),
	occurrences(T,A,B,N1,M1).
occurrences(List,A,B) :-
	dif(A,B),
	occurrences(List,A,B,0,0).

elem_x_count(X,X,(Old+1),Old):- !.
elem_x_count(_,_,Old,Old):- !.

/*
sceglie_attributo( +Attributi, +Esempi, -MigliorAttributo):
seleziona l'Attributo che meglio discrimina le classi
*/
sceglie_attributo( Attributi, Esempi, MigliorAttributo) :-
	bagof( Dis/At,
		(member(At,Attributi) , disuguaglianza(Esempi,At,Dis)),
		Disis),
		max_dis(Disis, _, MigliorAttributo).

%TODO: verifica cosa fa '=' perche non lo sappiamo 
max_dis([(H/A)|T], Y, Best):-  
	max_dis(T, X, Best_X),
    (H > X ->
    	(H = Y, A = Best);
    	(Y = X, Best = Best_X)).
max_dis([(X/A)], X, A).

/*
disuguaglianza(+Esempi, +Attributo, -Dis):
Dis è la disuguaglianza combinata dei sottoinsiemi degli esempi
partizionati dai valori dell'Attributo
*/
disuguaglianza( Esempi, Attributo, Dis) :-
	a( Attributo, AttVals),
	entropiaDataset(Esempi, EntropiaDataset),
	somma_pesata_shannon(Esempi, Attributo, AttVals, 0, SpShannon),
	somma_gain_ratio(Esempi, Attributo, AttVals, 0, SpGain),
	Gain is EntropiaDataset - SpShannon,
	controllo(Gain, SpGain, Dis).

% procedura per evitare la divisione con lo 0
% ottenuto nel momento in cui la lista e' vuota
controllo(_, 0.0, 0):- !.
controllo(_, 0, 0):- !.
controllo(Gain, Sp, GainRatio):-
	% Dis is Gain Ratio xP
	GainRatio is Gain/(-Sp).

/* TODO: Da rimuovere ma verifica
controllo(Gain, Sp, GainRatio):-
	(Sp = 0.0) -> GainRatio is 0 ;
	(
		% Dis is Gain Ratio xP
		GainRatio is Gain/(-Sp)
	).
*/

% entropiaDataset(_, EntropiaDataset)
entropiaDataset(Esempi, EntropiaDataset) :-
	findall(sick,
			(member(e(sick, _),Esempi)), EsempiSick),
	length(Esempi, N),
	length(EsempiSick, NSick),
	PSick is NSick/N,
	entropia(PSick, EntropiaDataset).


sommatoria(Esempi, Att, Val, Qattr, P_va):-
	length(Esempi,N),												
	findall(C,														
			(member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])),	
			EsempiSoddisfatti),				     					
	length(EsempiSoddisfatti, NVal),	
	
	findall(P,							
			(bagof(1, member(sick,EsempiSoddisfatti), L), length(L,NVC), P is NVC/NVal),
			Q),
	nth0(0, Q, Qattr),
	P_va is (NVal/N).


somma_pesata_shannon( _, _, [], Somma, Somma).
somma_pesata_shannon( Esempi, Att, [Val|Valori], SommaParziale, Somma) :-
	sommatoria(Esempi, Att, Val, Qattr, P_va),
	Qattr > 0, !,

	entropia(Qattr, EntropiaAttr),
	NuovaSommaParziale is SommaParziale + (P_va) * EntropiaAttr ,	
	somma_pesata_shannon(Esempi,Att,Valori,NuovaSommaParziale,Somma)
	;
	somma_pesata_shannon(Esempi,Att,Valori,SommaParziale,Somma).

% Sommatoria gain ratio
somma_gain_ratio( _, _, [], Somma_g, Somma_g).
somma_gain_ratio( Esempi, Att, [Val|Valori], SommaParziale_g, Somma_g) :-
	sommatoria(Esempi, Att, Val, Qattr, P_va),
	Qattr > 0, !,

	log2(P_va, X),
	NuovaSommaParziale_g is SommaParziale_g + P_va * X,
	
	somma_gain_ratio(Esempi,Att,Valori,NuovaSommaParziale_g,Somma_g)
	;
	somma_gain_ratio(Esempi,Att,Valori,SommaParziale_g,Somma_g).

% TODO: IDEA accorpare sommatorie in un unico predicato
% perchè per il momento non è ottimizzato.


/* TODO: Da rimuovere ma verifica
somma_pesata_shannon( _, _, [], Somma, Somma).
somma_pesata_shannon( Esempi, Att, [Val|Valori], SommaParziale, Somma) :-
	length(Esempi,N),												
	findall(C,														
			(member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])),	
			EsempiSoddisfatti),				     					
	length(EsempiSoddisfatti, NVal),	
	
	findall(P,							
			(bagof(1, member(sick,EsempiSoddisfatti), L), length(L,NVC), P is NVC/NVal),
			Q),
	nth0(0, Q, Qattr),
	Qattr > 0, !,
	entropia(Qattr, EntropiaAttr),

	P_va is (NVal/N),
	NuovaSommaParziale is SommaParziale + (P_va) * EntropiaAttr ,	
	somma_pesata_shannon(Esempi,Att,Valori,NuovaSommaParziale,Somma)
	;
	somma_pesata_shannon(Esempi,Att,Valori,SommaParziale,Somma).

% Sommatoria gain ratio
somma_gain_ratio( _, _, [], Somma_g, Somma_g).
somma_gain_ratio( Esempi, Att, [Val|Valori], SommaParziale_g, Somma_g) :-
	length(Esempi,N),												
	findall(C,														
			(member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])),	
			EsempiSoddisfatti),				     					
	length(EsempiSoddisfatti, NVal),
	
	findall(P,							
			(bagof(1, member(sick,EsempiSoddisfatti), L), length(L,NVC), P is NVC/NVal),
			Q),
	nth0(0, Q, Qattr),
	Qattr > 0, !,

	P_va is (NVal/N),

	log2(P_va, X),
	NuovaSommaParziale_g is SommaParziale_g + P_va * X,
	
	somma_gain_ratio(Esempi,Att,Valori,NuovaSommaParziale_g,Somma_g)
	;
	somma_gain_ratio(Esempi,Att,Valori,SommaParziale_g,Somma_g).*/	 	





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

log2(P, Log2ris):-
	log(P,X),
	log(2,Y),
	Log2ris is X/Y.

/* B(q) = -[(q)log_2(q) + (1-q)log_2(1-q)] */
entropia(1, 0):- !.
entropia(Q, H):-
	InvQ is 1-Q,
	log2(Q, LogQ),
	log2(InvQ, LogInvQ),
	H is -((Q * LogQ) + (InvQ * LogInvQ)).

/* TODO: Da rimuovere ma verifica
entropia(Q, H):-
	(Q = 1) -> H is 0 ;
	(InvQ is 1-Q,
	log2(Q, LogQ),
	log2(InvQ, LogInvQ),
	H is -((Q * LogQ) + (InvQ * LogInvQ))).
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
induce_alberi(Attributi, Valori, AttRimasti, Esempi, SAlberi):
induce decisioni SAlberi per sottoinsiemi di Esempi secondo i Valori
degli Attributi
*/
induce_alberi(_,[],_,_,[]).     												% nessun valore, nessun sotto albero
induce_alberi(Att,[Val1|Valori],AttRimasti,Esempi,[Val1:Alb1|Alberi])  :-
	attval_subset(Att=Val1,Esempi,SottoinsiemeEsempi),
	induce_albero(AttRimasti,SottoinsiemeEsempi,Alb1),
	induce_alberi(Att,Valori,AttRimasti,Esempi,Alberi).

/*
attval_subset( Attributo = Valore, Esempi, Subset):
   Subset è il sottoinsieme di Examples che soddisfa la condizione
   Attributo = Valore
*/
attval_subset(AttributoValore,Esempi,Sottoinsieme) :-
	findall(e(C,O),
			(member(e(C,O),Esempi),
			soddisfa(O,[AttributoValore])),
			Sottoinsieme).

% soddisfa(Oggetto, Descrizione):
soddisfa(Oggetto,Congiunzione) :-
	\+ (member(Att=Val,Congiunzione),
		member(Att=ValX,Oggetto),
		ValX \== Val).

del(T,[T|C],C) :- !.
del(A,[T|C],[T|C1]) :-
	del(A,C,C1).
