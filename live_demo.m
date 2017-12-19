addpath('matlab-midi-master/src');

% Generate [input, continuation] midi files for all found 4 bar sections of
% each individual track.
filename = 'test-midi/3a0e08597088225b13edaab26ce1e7d2.mid';
midi = readmidi(filename);
[bpm, ts] = time_calc(midi);
notes = midiInfo(midi, 0, [4]);

% Generates continuations data for found 4 bar sections.
phrase_length = 8;
output_data = contins_for_file(filename,1,phrase_length);

% Adds analysis data for each continuation.
output_data = analyze_contins(output_data,phrase_length,bpm,ts,true);

% All generated midi files are now available in the generated output folder.

%%
% MUST FIRST LOAD TOTAL_DATASET FROM FILE. This is the dataset that we
% generated which includes 745 samples.

plot_analysis(total_dataset);


