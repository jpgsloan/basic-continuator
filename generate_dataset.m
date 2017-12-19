% This script will generate a dataset of continuations for a folder of midi
% files. 
% Resulting dataset is an nx8 array, where n is the number of found 4 bar
% phrases in the midi files. 
% The eight columns of the resulting matrix are as follows:
%   1. Filename that sample is taken from
%   2. Track number of midi file
%   3. Bucket number (i.e., where in the track the phrase is)
%   4. The input phrase (4 bars)
%   5. The ground truth phrase (the 4 bars directly following input)
%   6. The generated continuation (same length as input)
%   7. Edit distance of continuation vs. ground truth
%   8. Longest common subsequence of continuation vs. ground truth
%
%   Must include the lakh dataset in the project folder. Path currently
%   used is lmd_full/{# of folder}.
%
% KNOWN ISSUE: there is a bug in the midi framework used, that crashes when
% reading midi files with unexpected headers. This prevents running on the
% entirety of the LAKH dataset, but still works for a large portion of it.

addpath('lmd_full/5/');
files = dir('lmd_full/5/*.mid');
midi_cells = cell(size(files));

dataset = [];

for i = 1:size(files,1)    
    filename = ['lmd_full/5/',files(i).name];
    midi = readmidi(filename);
    [bpm, ts] = time_calc(midi);

    output_data = contins_for_file(filename,1,4);
    output_data = analyze_contins(output_data,4,bpm,ts,false);
    
    dataset = [dataset; output_data];
end




