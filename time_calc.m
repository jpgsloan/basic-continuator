function [bpm, time_sig] = time_calc(midi)

    % Function that returns the tempo (BPM) and time signature from a MIDI
    % file

midi_tempo = [];
time_sig = [];
for i = 1:size(midi.track,2)

    tempo_message = find([midi.track(i).messages(:).type]==81);
    if ~isempty(tempo_message)
        midi_tempo = midi.track(i).messages(tempo_message).data;
    end
    
    t_sig_message = find([midi.track(i).messages(:).type]==88);
    if ~isempty(t_sig_message)
        time_sig = midi.track(i).messages(t_sig_message).data;  
    end
    
    if i==size(midi.track,2) && isempty(midi_tempo)
        midi_tempo = [7;161;32];
    end
    
    if i==size(midi.track,2) && isempty(time_sig)
        time_sig = [4;2;24;8];
    end
    
    if ~isempty(midi_tempo)
        break
    end
end

hex_base = [16^4;16^2;16^0];

bpm = (60 * 10^6) / sum(midi_tempo .* hex_base);

end