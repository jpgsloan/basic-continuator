function [output_data] = contins_for_file(filename, threshold, phrase_length)

% read midi file.
midi = readmidi(filename);

% sort the midi notes into buckets (e.g. 4 bar phrases).
[buckets, buck_dur] = buck_sort(midi, phrase_length);

% calculate which buckets are good for training.
bools = valid_buckets(buckets, threshold, buck_dur);

% build prefix trees with valid buckets.
trees = build_trees(buckets, bools);

% predict continuation phrases, and construct output_data. 
output_data = continuation_data(buckets, bools, trees, filename);


end