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

midi = readmidi('test-midi/3a0e08597088225b13edaab26ce1e7d2.mid');
notes = midiInfo(midi, 0, [4]);

threshold = 0.8;
[buckets, buck_dur] = buck_sort(midi, 4);
disp('');
%bool = analyze_bucket(buckets, 1.5, 0.5)

for i = 1:size(buckets,2)
    for j = 1:size(buckets,1)
        cur_bucket = buckets(j,i);
        bools(j,i) = analyze_bucket(cur_bucket{1}, buck_dur, threshold);
    end
end

disp(bools);
%track = midi.track(1);
%notes(1:5,1:5)


%% also, can do piano-roll showing velocity:
[PR,t,nn] = piano_roll(notes,1);

figure;
imagesc(t,nn,PR);
axis xy;
xlabel('time (sec)');
ylabel('note number');
