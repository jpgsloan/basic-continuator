%% build an example prefix tree
clear all
dummy_input_1 = [1 1 1 1 1; 0 0 0 0 0; 57 59 59 60 62; 99 68 68 75 88;
    0.9779 1.2005 1.2010 1.4115 1.6250; 0.9788 1.3037 1.3500 1.5299 1.8268;
    3 4 5 7 9; 8 6 8 10 11]';

%dummy_input_2 = [57 59 59 60];
dummy_input_2 = [1 1 1 1 1 1; 0 0 0 0 0 0; 57 59 59 59 59 60; 99 68 68 75 75 88;
    0.9779 1.2005 1.2010 1.4115 1.4115 1.6250; 0.9788 1.3037 1.3500 1.5299 1.5299 1.8268;
    3 4 5 7 8 9; 8 6 8 10 12 11]';

test_tree = Prefix_tree;
test_tree.parse(dummy_input_1)
%% add more input to example tree

test_tree.parse(dummy_input_2)

%% generate example continuation of length 4
a = Node([1, 0, 57, 99, 0, 0.24, 1, 2], [], [], []);
b = Node([1, 0, 59, 99, 0, 0.24, 1, 2], [], [], []);
bb = Node([1 1; 0 0; 59 59; 99 100; 0 0; 0.24 0.24; 1 2; 3 4]', [], [], []);
c = Node([1; 0; 60; 99; 0; 0.24; 1; 2], [], [], []);

out_seq_nodes = test_tree.generate([a b], 4);
out_seq = test_tree.generate_notes([a b], 4);

%% generate [input,continuation] midi files

addpath('matlab-midi-master/src');
filename = 'test-midi/3a0e08597088225b13edaab26ce1e7d2.mid';
midi = readmidi(filename);
[bpm, ts] = time_calc(midi);
notes = midiInfo(midi, 0, [5]);
output_data = contins_for_file(filename,1,4);

%%
output_data = analyze_contins(output_data,4,bpm,ts,true)

%% generate chords

addpath('matlab-midi-master/src');

filename = 'test-midi/3a0e08597088225b13edaab26ce1e7d2.mid';
midi = readmidi(filename);
notes = midiInfo(midi, 0, [7]);
disp('=====num of notes======');
size(notes,1)
disp('=====num of polyphonic groups======');
chords = group_chords(notes);
size(chords,2)

test_tree = Prefix_tree;
test_tree.parse_poly(notes);

%% test new midi framework
addpath('midi_lib');
javaaddpath('midi_lib/KaraokeMidiJava.jar')

note_matrix = readmidi_java('test-midi/3a0e08597088225b13edaab26ce1e7d2.mid');
track_3 = note_matrix(note_matrix(:,3) == 3,:);
writemidi_seconds(track_3,'output/hmmm.mid')



