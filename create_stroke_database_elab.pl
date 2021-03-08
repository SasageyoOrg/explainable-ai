
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a(Gender, Age, Hypertension, Heart_disease, Ever_married, Work_type, Residence_type, Avg_glucose_level, Bmi, Smoking_status, Target).

id                   : numerico, indice univoco del paziente
gender               : binario, sesso del paziente (0 = Femmina, 1 = Maschio)
age                  : numerico, età del paziente
hypertension         : binario, presenza di ipertenisone (0 = No, 1 = Si)
heart_disease        : binario, presenza di cardiopatia, malattia caridaca (0 = No, 1 = Si)
ever_married         : binario, sposato (0 = No, 1 = Si)
work_type            : numerico, tipo di lavoro (0 = Never worked, 1= Children, 2 = Private, 3 = Self employed, 4 = Govt job)
residence_type       : binario, dove abita (0 = Campagnia, 1 = Città)
avg_glucose_level    : numerico, livello medio di gluccosio nel sangue, RANGE:
                                                                                X < 110       Rischio Nullo
                                                                                110 < X < 119 Rischio Moderato
                                                                                119 < X < 125 Rischio Alto
				                                                                X > 125       Rischio Molto Alto
bmi                  : numerico, letteralmente body mass index, indice di massa corporea, RANGE:
                                                                                                X < 18  	SOTTOPESO
                                                                                                18 < X < 25	NORMOPESO
                                                                                                25 < X < 30	SOVRAPPESO
                                                                                                X > 30      OBESITÀ
smoking_status       : numerico, tipo di fumatore (0 = Never smoked, 1 = Formerly smoked, 3 = Smokes)
target               : booleano, indica se il passeggero ha avuto un ictus (0 = No, 1 = Si)

es
a(Male,67.0,0,1,Yes,Private,Urban,228.69,36.6,formerly_smoked,1).
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


:- ensure_loaded(stroke_database).

start :-
    tell('stroke_database_ela.pl'),
    a(Gender,Age,Hypertension,Heart_disease,Ever_married,Work_type,Residence_type,Avg_glucose_level,Bmi,Smoking_status,Target),
    write('aa('), write(Target),
    write(','),   write(Gender),
    write(','),   ( number(Age),           Age =< 30, write('0-30');
                    number(Age), Age > 30, Age =< 40, write('30-40');
                    number(Age), Age > 40, Age =< 50, write('40-50');
                    number(Age), Age > 50, Age =< 60, write('50-60');
				    number(Age), Age > 60, Age =< 70, write('60-70');
				    number(Age), Age > 70, Age =< 80, write('70-80');
				    number(Age), Age > 80,            write('80')), 
    write(','),   write(Hypertension),
    write(','),   write(Heart_disease), 
    write(','),   write(Ever_married), 
    write(','),   write(Work_type),  
    write(','),   write(Residence_type), 
    write(','),   ( number(Avg_glucose_level),                          Avg_glucose_level =< 110, write('0-110');
                    number(Avg_glucose_level), Avg_glucose_level > 110, Avg_glucose_level =< 119, write('110-119');
                    number(Avg_glucose_level), Avg_glucose_level > 119, Avg_glucose_level =< 125, write('119-125');
				    number(Avg_glucose_level), Avg_glucose_level > 125,                           write('125')),
    write(','),   ( number(Bmi),           Bmi =< 17, write('0-18');
                    number(Bmi), Bmi > 17, Bmi =< 25, write('18-25');
                    number(Bmi), Bmi > 25, Bmi =< 30, write('25-30');
				    number(Bmi), Bmi > 30,            write('30')), 
    write(','),   write(Smoking_status), 
        writeln(').'),
    fail.

start :- told.