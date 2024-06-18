:- use_module(library(pce)).
:- [hechos].  % Cargar el archivo de hechos

% Predicado para crear una ventana con un combobox
create_window :-
    new(Window, dialog('Prolog GUI ComboBox Example')),
    % Crear y añadir el título centrado
    new(Title, text('Titulo de la aplicacion')),
    send(Title, alignment, center),
    send(Window, append, Title),
    % Añadir el combobox de artistas
    new(ArtistComboBox, menu('Acordes mas usado por artista', cycle)),
    populate_artist_combobox(ArtistComboBox),
    send(Window, append, ArtistComboBox),
    % Añadir el botón para mostrar acordes
    send(Window, append, button(mostrar_acordes, message(@prolog, show_chords, ArtistComboBox?selection))),
    % Crear un contenedor crear acorde para la nota y el botón "Siguiente"
    new(NoteRow, dialog_group(crear_acorde)),
    % Añadir el combobox de notas al contenedor
    new(NoteComboBox, menu('Selecciona una nota', cycle)),
    populate_note_combobox(NoteComboBox),
    send(NoteRow, append, NoteComboBox),
    % Añadir el botón "Siguiente" al contenedor
    send(NoteRow, append, button(siguiente, message(@prolog, select_chord_type, NoteComboBox?selection))),
    % Añadir el contenedor a la ventana principal
    send(Window, append, NoteRow),
    send(Window, open).

% Predicado para poblar el combobox con artistas
populate_artist_combobox(ComboBox) :-
    setof(Artist, Chords^acordes_verso(Artist, Chords), Artists),
    forall(member(Artist, Artists),
           send(ComboBox, append, menu_item(Artist))).

% Predicado para poblar el combobox con notas
populate_note_combobox(ComboBox) :-
    setof(Note, nota(Note), Notes),
    forall(member(Note, Notes),
           send(ComboBox, append, menu_item(Note))).

% Predicado para mostrar los acordes más frecuentes del artista seleccionado
show_chords(Artist) :-
    acordes_mas_frecuentes(Artist, AcordesMasFrecuentes),
    atomic_list_concat(AcordesMasFrecuentes, ', ', AcordesString),
    send(@display, inform, string('Acordes más frecuentes de %s: %s', Artist, AcordesString)).

% Predicado para mostrar los hechos de notas
show_notes_facts :-
    findall(Note, nota(Note), Notes),
    atomic_list_concat(Notes, ', ', NotesString),
    send(@display, inform, string('Notas disponibles: %s', NotesString)).

% Predicado para seleccionar tipo de acorde
select_chord_type(Note) :-
    new(TypeWindow, dialog('Selecciona tipo de acorde')),
    % Añadir el combobox para tipo de acorde
    new(ChordTypeComboBox, menu('Selecciona tipo de acorde', cycle)),
    send(ChordTypeComboBox, append, menu_item(mayor)),
    send(ChordTypeComboBox, append, menu_item(menor)),
    send(TypeWindow, append, ChordTypeComboBox),
    % Añadir el botón para crear acorde
    send(TypeWindow, append, button(crear_acorde, message(@prolog, create_chord, Note, ChordTypeComboBox?selection))),
    send(TypeWindow, open).

% Predicado para crear un acorde y mostrarlo
create_chord(Note, ChordType) :-
    (ChordType == mayor ->
        acorde_mayor(Note, ChordNotes)
    ;
        acorde_menor(Note, ChordNotes)
    ),
    atomic_list_concat(ChordNotes, ', ', ChordString),
    send(@display, inform, string('Acorde %s %s: %s', ChordType, Note, ChordString)).

% Predicado principal para iniciar la aplicación
:- create_window.