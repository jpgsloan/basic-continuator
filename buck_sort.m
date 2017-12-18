function [buck_notes, buck_dur] = buck_sort(midi, bars)

[bpm, ts] = time_calc(midi);

[notes, end_time] = midiInfo(midi, 0, []);
end_time = max(end_time);

[buck_lin, buck_dur] = buck_calc(bpm, ts, bars, end_time);

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