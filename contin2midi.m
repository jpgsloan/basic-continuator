function [] = contin2midi(continuation,bucket,bpm,filename)

    % Writes MIDI file from continuation
    
    % Input args are:
        % continuation - array of MIDI pitch values
        % bucket - the nx8 matrix used as input to generate continuation
        % bpm - the tempo of original MIDI file in beats per minute
        % filename - desired filename of output midi file
        
    % There is no return
    
    bucket(:,1) = 1; % set track to 1
    bucket(:,2) = 0; % set channel to 0
    bucket(:,3) = continuation; % set note values to continuation
    bucket(:,5:6) = bucket(:,5:6) - min(bucket(:,5)); % normalize start times
    
    uspb = (60 * 10^6)/bpm; % convert beats / minute to microseconds / beat
    
    midi = matrix2midi_notempo(bucket,480,uspb); % generate midi struct
    
    writemidi(midi,filename);

end