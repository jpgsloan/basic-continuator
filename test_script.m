clear;
dummy_input_1 = [57 59 60 62];
dummy_input_2 = [57 59 59 60];

test_tree = Prefix_tree;

test_tree.parse(dummy_input_1)
%%
test_tree.parse(dummy_input_2)
%%
dummy_input_3 = [57 59 60 57];

test_tree.parse(dummy_input_3);

%%
a = Node(57, [], []);
b = Node(59, [], []);
c = Node(60, [], []);

out_seq = test_tree.generate([a b], 4);

%% midi

midi = readmidi('3a0e08597088225b13edaab26ce1e7d2.mid');
notes = midiInfo(midi, 0, [4]);

bool = analyze_bucket(notes(1:2,:), 1.5, 0.5)

%track = midi.track(1);
%notes(1:5,1:5)


%% also, can do piano-roll showing velocity:
[PR,t,nn] = piano_roll(notes,1);

figure;
imagesc(t,nn,PR);
axis xy;
xlabel('time (sec)');
ylabel('note number');
