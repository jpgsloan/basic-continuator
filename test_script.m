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

out_seq_nodes = test_tree.generate([a b], 4);
out_seq = test_tree.generate_notes([a b], 4);

%% midi

midi = readmidi('test-midi/3a0e08597088225b13edaab26ce1e7d2.mid');
notes = midiInfo(midi, 0, [4]);

[buckets, buck_dur] = buck_sort(midi, 4);

% calculate which buckets are good for training.
threshold = 0.8;
bools = zeros(size(buckets));
for i = 1:size(buckets,2)
    for j = 1:size(buckets,1)
        cur_bucket = buckets(j,i);
        if ~isempty(cur_bucket{1})
            bools(j,i) = analyze_bucket(cur_bucket{1}, buck_dur, threshold);
            bools(j,i) = ~is_polyphonic(cur_bucket{1});
        end
    end
end


% for each track, build prefix tree.
trees = Prefix_tree.empty(0,size(buckets,2));
for k = 1:size(buckets,2)
    
    % get indeces where nonzero (aka buckets are good to use)
    index = find(bools(:,k));
    cur_track = buckets(:,k);
    good_bucks = cur_track(index);
    
    cur_tree = Prefix_tree;
    
    % parse training input into tree
    if ~isempty(index) 
        for l=1:size(good_bucks,1)
            cur_good_buck = good_bucks(l,1);
            cur_tree.parse(bucket2notes(cur_good_buck{1}));
        end
    end
    trees(1,k) = cur_tree;
end


% for each tree, create [input, continuation] pairs.
trees(4).generate_notes(notes2nodes(notes_test),length_test)

% convert new notes to midi file.



%% also, can do piano-roll showing velocity:
[PR,t,nn] = piano_roll(notes,1);

figure;
imagesc(t,nn,PR);
axis xy;
xlabel('time (sec)');
ylabel('note number');
