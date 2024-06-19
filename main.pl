:- use_module(library(pce)).
:- [hechos]. 

frecuencia_acordes(Artista, Predicado, Frecuencias) :-
    findall(Acordes, call(Predicado, Artista, Acordes), ListaAcordes),
    flatten(ListaAcordes, TodosAcordes),
    msort(TodosAcordes, AcordesOrdenados),
    pack(AcordesOrdenados, AcordesEmpaquetados),
    maplist(longitud, AcordesEmpaquetados, Frecuencias).

acordes_mas_frecuentes(Artista, Predicado, AcordesMasFrecuentes) :-
    frecuencia_acordes(Artista, Predicado, Frecuencias),
    sort(0, @>=, Frecuencias, FrecuenciasOrdenadas),
    take(4, FrecuenciasOrdenadas, FrecuenciasTop),
    maplist(snd, FrecuenciasTop, AcordesMasFrecuentes).

create_window :-
    new(Window, dialog('Sistema Experto')),
    send(Window, size, size(400, 300)),
    send(Window, append, new(_, label(title, 'Recomendacion de Acordes', bold))),
    new(ArtistComboBox, menu('Selecciona un artista', cycle)),
    populate_artist_combobox(ArtistComboBox),
    send(Window, append, ArtistComboBox),
    new(TypeComboBox, menu('Selecciona el tipo de acorde', cycle)),
    send(TypeComboBox, append, menu_item(verso)),
    send(TypeComboBox, append, menu_item(precoro)),
    send(TypeComboBox, append, menu_item(coro)),
    send(TypeComboBox, append, menu_item(puente)),
    send(Window, append, TypeComboBox),
    send(Window, append, button(mostrar_acordes, message(@prolog, show_chords, ArtistComboBox?selection, TypeComboBox?selection))),
    new(NoteRow, dialog_group(crear_acorde)),
    new(NoteComboBox, menu('Selecciona una nota', cycle)),
    populate_note_combobox(NoteComboBox),
    send(NoteRow, append, NoteComboBox),
    send(NoteRow, append, button(siguiente, message(@prolog, select_chord_type, NoteComboBox?selection))),
    send(Window, append, NoteRow),
    send(Window, open).

populate_artist_combobox(ComboBox) :-
    setof(Artist, Chords^acordes_verso(Artist, Chords), Artists),
    forall(member(Artist, Artists),
           send(ComboBox, append, menu_item(Artist))).

populate_note_combobox(ComboBox) :-
    setof(Note, nota(Note), Notes),
    forall(member(Note, Notes),
           send(ComboBox, append, menu_item(Note))).

show_chords(Artist, Type) :-
    chord_predicate(Type, Predicate),
    acordes_mas_frecuentes(Artist, Predicate, AcordesMasFrecuentes),
    atomic_list_concat(AcordesMasFrecuentes, ', ', AcordesString),
    send(@display, inform, string('Acordes mas frecuentes de %s (%s): %s', Artist, Type, AcordesString)).

chord_predicate(verso, acordes_verso).
chord_predicate(precoro, acordes_precoro).
chord_predicate(coro, acordes_coro).
chord_predicate(puente, acordes_puente).

show_notes_facts :-
    findall(Note, nota(Note), Notes),
    atomic_list_concat(Notes, ', ', NotesString),
    send(@display, inform, string('Notas disponibles: %s', NotesString)).

select_chord_type(Note) :-
    new(TypeWindow, dialog('Selecciona tipo de acorde')),
    new(ChordTypeComboBox, menu('Selecciona tipo de acorde', cycle)),
    send(ChordTypeComboBox, append, menu_item(mayor)),
    send(ChordTypeComboBox, append, menu_item(menor)),
    send(ChordTypeComboBox, append, menu_item(septima_menor)),
    send(ChordTypeComboBox, append, menu_item(septima_mayor)),
    send(TypeWindow, append, ChordTypeComboBox),
    send(TypeWindow, append, button(crear_acorde, message(@prolog, create_chord, Note, ChordTypeComboBox?selection))),
    send(TypeWindow, open).

create_chord(Note, ChordType) :-
    (ChordType == mayor ->
        acorde_mayor(Note, ChordNotes);
    ChordType == menor ->
        acorde_menor(Note, ChordNotes);
    ChordType == septima_menor ->
        acorde_septima_menor(Note, ChordNotes)
    ;
        acorde_septima_mayor(Note, ChordNotes)
    ),
    atomic_list_concat(ChordNotes, ', ', ChordString),
    send(@display, inform, string('Acorde %s %s: %s', ChordType, Note, ChordString)).

:- create_window.
