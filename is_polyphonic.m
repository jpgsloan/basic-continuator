function [is_poly] = is_polyphonic(bucket)
    % Check if bucket of notes is polyphonic.
    % Returns true if any two notes begin simultaneously.
    % Assumes bucket is already sorted by midi start time, in col 5.
    
    is_poly = false;

    for i = 1:(size(bucket,1)-1)        
        cur_note = bucket(i,5);
        next_note = bucket(i+1,5);

        if cur_note == next_note 
            is_poly = true;
            break;
        end  
    end
end