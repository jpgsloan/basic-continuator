function [is_dense] = analyze_bucket(bucket, buck_dur, threshold) 
% Calculate the note density within the bucket 
if isempty(bucket)
    is_dense = false;
    return;
end

is_dense = false;

start_times = bucket(:,5);
end_times = bucket(:,6);

total_duration = sum(end_times - start_times);
percent_dur = total_duration / buck_dur;

if percent_dur > threshold 
   is_dense = true; 
end

end