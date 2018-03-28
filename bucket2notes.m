function [note_list] = bucket2notes(bucket)
% Extracts the midi note values for a matrix of notes.
    note_list = bucket(:,3)';
end