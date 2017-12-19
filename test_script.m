%% build an example prefix tree

dummy_input_1 = [57 59 60 62];
dummy_input_2 = [57 59 59 60];

test_tree = Prefix_tree;

test_tree.parse(dummy_input_1)
%% add more input to example tree

test_tree.parse(dummy_input_2)
%% add 3rd input
dummy_input_3 = [57 59 60 57];
test_tree.parse(dummy_input_3);

%% generate example continuation of length 4
a = Node(57, [], []);
b = Node(59, [], []);
c = Node(60, [], []);

out_seq_nodes = test_tree.generate([a b], 4);
out_seq = test_tree.generate_notes([a b], 4);

%% generate [input,continuation] midi files

filename = 'test-midi/3a0e08597088225b13edaab26ce1e7d2.mid';
midi = readmidi(filename);
[bpm, ts] = time_calc(midi);
notes = midiInfo(midi, 0, [4]);
output_data = contins_for_file(filename,1,4);
output_data = analyze_contins(output_data,4,bpm,ts,true);
