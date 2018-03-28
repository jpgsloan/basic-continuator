function [buck_notes, buck_dur] = buck_sort(midi, bars)
% Sort midi notes into buckets of given size (e.g. 4 bar phrases).
% midi  Struct containing midi info for a track. Can retrieve
%       Nx8 matrix where N is the number of midi notes, each with 8 fields
%       of information. (including note number, start/end times, etc.)
% bars  The number of bars per bucket.
%
% buck_notes  A cell matrix in which each column is a track of the midi
%             file, and rows contain buckets of midi notes.
% buck_dur    Duration of bucket in seconds, based on tempo of track.

[bpm, ts] = time_calc(midi);

% Retrieve notes matrix and end time of the track
[notes, end_time] = midiInfo(midi, 0, []);
end_time = max(end_time);

[buck_lin, buck_dur] = buck_calc(bpm, ts(1), bars, end_time);

buck_notes = cell(length(buck_lin)-1,length(midi.track));

for i=1:length(midi.track)
   
    track_notes = notes(notes(:,1)==i,:);
    if isempty(track_notes)
        continue
    end
    
    for j=1:length(buck_lin)-1
        buck_notes{j,i} = track_notes((track_notes(:,5)>=buck_lin(j)) & (track_notes(:,5)<buck_lin(j+1)),:);   
    end
end

end