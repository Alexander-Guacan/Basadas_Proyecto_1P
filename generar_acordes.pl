nota('Cb').
nota('C').
nota('C#').
nota('Db').
nota('D').
nota('D#').
nota('Eb').
nota('E').
nota('Fb').
nota('F').
nota('F#').
nota('Gb').
nota('G').
nota('G#').
nota('Ab').
nota('A').
nota('A#').
nota('Bb').
nota('B').

semitono('Cb', 'C').
semitono('C', 'C#').
semitono('C#', 'D').
semitono('Db', 'D').
semitono('D', 'D#').
semitono('D#', 'E').
semitono('Eb', 'E').
semitono('E', 'F').
semitono('Fb', 'F').
semitono('F', 'F#').
semitono('F#', 'G').
semitono('Gb', 'G').
semitono('G', 'G#').
semitono('G#', 'A').
semitono('Ab', 'A').
semitono('A', 'A#').
semitono('A#', 'B').
semitono('Bb', 'B').
semitono('B', 'C').

tono('Cb', 'C#').
tono('C', 'D').
tono('C#', 'D#').
tono('Db', 'D#').
tono('D', 'E').
tono('D#', 'F').
tono('Eb', 'F').
tono('E', 'F#').
tono('Fb', 'F#').
tono('F', 'G').
tono('F#', 'G#').
tono('Gb', 'G#').
tono('G', 'A').
tono('G#', 'A#').
tono('Ab', 'A#').
tono('A', 'B').
tono('A#', 'C').
tono('Bb', 'C').
tono('B', 'C#').

segunda_menor(Raiz, Nota) :-
    nota(Raiz),
    semitono(Raiz, Nota).

segunda_mayor(Raiz, Nota) :-
    nota(Raiz),
    tono(Raiz, Nota).

tercera_menor(Raiz, Nota) :-
    nota(Raiz),
    tono(Raiz, SegundaMayor),
    semitono(SegundaMayor, Nota).

tercera_mayor(Raiz, Nota) :-
    nota(Raiz),
    segunda_mayor(Raiz, SegundaMayor),
    tono(SegundaMayor, Nota).

cuarta_justa(Raiz, Nota) :-
    nota(Raiz),
    tercera_mayor(Raiz, TerceraMayor),
    semitono(TerceraMayor, Nota).

cuarta_aumentada(Raiz, Nota) :-
    nota(Raiz),
    tercera_mayor(Raiz, TerceraMayor),
    tono(TerceraMayor, Nota).

quinta_justa(Raiz, Nota) :-
    nota(Raiz),
    cuarta_aumentada(Raiz, CuartaAumentada),
    semitono(CuartaAumentada, Nota).

sexta_menor(Raiz, Nota) :-
    nota(Raiz),
    cuarta_aumentada(Raiz, CuartaAumentada),
    tono(CuartaAumentada, Nota).

sexta_mayor(Raiz, Nota) :-
    nota(Raiz),
    quinta_justa(Raiz, QuintaJusta),
    tono(QuintaJusta, Nota).

septima_menor(Raiz, Nota) :-
    nota(Raiz),
    sexta_mayor(Raiz, SextaMayor),
    semitono(SextaMayor, Nota).

septima_mayor(Raiz, Nota) :-
    nota(Raiz),
    sexta_mayor(Raiz, SextaMayor),
    tono(SextaMayor, Nota).

acorde_mayor(Raiz, Notas) :-
    nota(Raiz),
    tercera_mayor(Raiz, TerceraMayor),
    quinta_justa(Raiz, QuintaJusta),
    Notas = [Raiz, TerceraMayor, QuintaJusta].

acorde_menor(Raiz, Notas) :-
    nota(Raiz),
    tercera_menor(Raiz, TerceraMenor),
    quinta_justa(Raiz, QuintaJusta),
    Notas = [Raiz, TerceraMenor, QuintaJusta].