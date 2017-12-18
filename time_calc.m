function [bpm, time_sig] = time_calc(midi)

    % Function that returns the tempo (BPM) and time signature from a MIDI
    % file

midi_tempo = [];

for i = 1:size(midi.track,2)

    midi_tempo = midi.track(i).messages(find([midi.track(i).messages(:).type]==81)).data;
    time_sig = midi.track(i).messages(find([midi.track(i).messages(:).type]==88)).data;
    
    if ~isempty(midi_tempo)
        break
    end
end

hex_base = [16^4;16^2;16^0];

bpm = (60 * 10^6) / sum(midi_tempo .* hex_base);

end