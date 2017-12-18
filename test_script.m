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

filename = 'test-midi/3a0e08597088225b13edaab26ce1e7d2.mid';
midi = readmidi(filename);
[bpm, ts] = time_calc(midi);
notes = midiInfo(midi, 0, [4]);

output_data = contins_for_file(filename,1,4);

mkdir('.','output');
for i=1:size(output_data,1)
    cur_input = output_data(i,4);
    cur_truth = output_data(i,5);
    cur_contin = output_data(i,6);
    
    % convert new notes to midi file.
    contin2midi(cur_contin{1},cur_input{1},bpm,ts,['output/dopeness',i,'.mid']);
    
    % calculate edit distance for pairs etc.
    edit_dist = edit_distance(cur_truth{1},cur_contin{1});

    % can also calculate longest common subsequence
end


% calculate edit distance for pairs etc.
% edit_dist = edit_distance(truth4,contin4);

% can also calculate longest common subsequence
% seqs = {truth4;contin4};
% longest_string = multiLCS(seqs);
% longest_seq = double(longest_string{1});
% longest_seq_len = numel(longest_seq);
%% also, can do piano-roll showing velocity:
[PR,t,nn] = piano_roll(notes,1);

figure;
imagesc(t,nn,PR);
axis xy;
xlabel('time (sec)');
ylabel('note number');
