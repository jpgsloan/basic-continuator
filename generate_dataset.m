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




