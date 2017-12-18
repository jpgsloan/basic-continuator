%% MIDI batch testing

files = dir('FF_midi/*.mid');
midi_cells = cell(size(files));

for i = 1:size(files,1)
    
    midi_cells{i} = readmidi(files(i).name);
    
end