function [bools] = valid_buckets(buckets, threshold, buck_dur)

% calculate which buckets are monophonic and more dense than the threshold.
% density is percentage of the duration of the bucket that is filled with a
% midi note.
bools = zeros(size(buckets));
for i = 1:size(buckets,2)
    for j = 1:size(buckets,1)
        cur_bucket = buckets(j,i);
        if ~isempty(cur_bucket{1})
            bools(j,i) = analyze_bucket(cur_bucket{1}, buck_dur, threshold);
            bools(j,i) = ~is_polyphonic(cur_bucket{1});
        end
    end
end

end