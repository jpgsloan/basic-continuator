function [output_data] = analyze_contins(data,phrase_length,bpm,ts,output_midi)

output_data = data;

mkdir('.','output');
for i=1:size(output_data,1)
    cur_input = output_data(i,4);
    cur_input_notes = cur_input{1}(:,3)';
    cur_truth = output_data(i,5);
    cur_truth_notes = cur_truth{1}(:,3)';
    cur_contins = output_data{i,6};
    
    % convert 1st continuation into midi file.
    if output_midi
        filename = output_data(i,1);
        track_num = output_data(i,2);
        buck_num = output_data(i,3);
        namesplit1 = strsplit(filename{1},'/');
        namesplit2 = strsplit(char(namesplit1(2)),'.');
        filename = namesplit2(1);
        output_filename = ['output/',filename{1},'-',int2str(track_num{1}),'-',int2str(buck_num{1}),'.mid'];
        contin2midi(cur_contins{1},cur_input{1},phrase_length,bpm,ts,output_filename);
    end
    
    edit_dist = zeros(1,size(cur_contins,2));
    longest_seq_len = zeros(1,size(cur_contins,2));
    for j=1:size(cur_contins,2)
        % calculate edit distance for each continuation/ground truth pair. 
        edit_dist(j) = edit_distance(cur_truth_notes,cur_contins{j});
        
        % calculate longest common subsequence for each pair.
        [d,dist,longest_string] = LCS(cur_truth_notes,int16(cur_contins{j}));
        longest_seq_len(j) = dist;
    end
    output_data{i,7} = edit_dist;
    output_data(i,8) = {longest_seq_len};
    
    % calculate edit dist of truth vs. input
    output_data{i,9} = edit_distance(cur_truth_notes,cur_input_notes);
end

end