function [chord_matrix] = group_chords(notes_matrix)
% returns a 1*N cell array of matrices. The inner matrices contain the polyphonic 
% note groupings of each separate section. 
% Everything ordered sequentially from top row to bottom row for inner mats.
% In order sequentially from 1 to N chords for outer matrix. 


i = 1;
chord_buckets = {notes_matrix(1,:)};
prev_note = notes_matrix(1,:);
notes_matrix = notes_matrix(2:end,:);

while ~isempty(notes_matrix)
    % number of rows in notes matrix == num of notes to process
    cur_note = notes_matrix(1,:);
    
    if is_overlapping(prev_note, cur_note) 
        chord_buckets{i} = [chord_buckets{i}; cur_note];
    else
        i = i + 1;
        chord_buckets{i} = cur_note;    
    end
    
    prev_note = cur_note;
    notes_matrix = notes_matrix(2:end,:);
end

chord_matrix = chord_buckets;
end