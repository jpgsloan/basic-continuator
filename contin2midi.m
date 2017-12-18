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
    
    midi = matrix2midi_notempo(bucket,480); % generate midi struct
    
    uspb = (60 * 10^6)/bpm; % convert beats / minute to microseconds / beat
    
    uspb_hex = encode_int(uspb,3);
    
    tempo = struct('used_running_mode',0,'deltatime',0,'midimeta',0,'type',81,'data',uspb_hex,'chan',[]);
    
    midi.track(1).messages = [tempo,midi.track(1).messages];
    
    writemidi(midi,filename);

end

% (copied from writemidi.m)
function A=encode_int(val,Nbytes)

A = zeros(Nbytes,1);  %ensure col vector (diff from writemidi.m...)
for i=1:Nbytes
  A(i) = bitand(bitshift(val, -8*(Nbytes-i)), 255);
end

end