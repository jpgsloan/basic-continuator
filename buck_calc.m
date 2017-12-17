function [buck_lin] = buck_calc(bpm, ts, bars, end_time)

    % Function that returns the duration of a bucket in seconds,
        % where the bucket is of length given in bars
        % with regards to bpm and time signature (ts)
    % and the time boundaries of each bucket in seconds
        % if the bucket length does not go evenly into the total length,
        % the last bucket is truncated

    buck_dur = ts * bars * 60 / bpm;
    
    buck_lin = 0:buck_dur:end_time;
    
    if mod(end_time, buck_dur) ~= 0
        buck_lin = [buck_lin, end_time];
    end

end