function [] = contin2midi(continuation,bucket,phrase_length,bpm,time_sig,filename)

    % Writes MIDI file from continuation
    
    % Input args are:
        % continuation - array of MIDI pitch values
        % bucket - the nx8 matrix used as input to generate continuation
        % bars - the number of bars used to create bucket
        % bpm - the tempo of original MIDI file in beats per minute
        % time_sig - the time signature of original MIDI file
        % filename - desired filename of output midi file
    
%    bucket(:,1) = 1; % set track to 1
%     bucket(:,2) = 0; % set channel to 0
    
%     output = bucket; % clone bucket
    
    
    
%     output(:,3) = continuation; % set note values to continuation
    
%     buck_dur = time_sig(1) * phrase_length * 60 / bpm;
    
%     output(:,5:6) = bucket(:,5:6) - min(bucket(:,5)) + buck_dur; % normalize start times to buck_dur
%     bucket(:,5:6) = bucket(:,5:6) - min(bucket(:,5)); % normalize to 0
%     
%     output = [bucket;output];
    
    notes = continuation(:,3);
    velocities = continuation(:,4);
	start_times = continuation(:,5);
    end_times = continuation(:,6);
    durations = end_times - start_times;
    midi = continuation;
    midi(:,1) = 0;
    midi(:,2) = 0;
    midi(:,3) = 1;
    midi(:,4) = notes;
    midi(:,5) = velocities;
    midi(:,6) = start_times;
    midi(:,7) = durations;
    midi = midi(:,1:7);
    
    uspb = (60 * 10^6)/bpm; % convert beats / minute to microseconds / beat
    
    
    
    %midi = matrix2midi_notempo(continuation,480,uspb,time_sig); % generate midi struct
    
    writemidi_seconds(midi,filename);

end