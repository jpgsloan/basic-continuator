function [trees] = build_trees(buckets, bools)

% for each track, build prefix tree.
trees = Prefix_tree.empty(0,size(buckets,2));
for k = 1:size(buckets,2)
    
    % get indeces where nonzero (aka buckets are good to use)
    index = find(bools(:,k));
    cur_track = buckets(:,k);
    good_bucks = cur_track(index);
    
    cur_tree = Prefix_tree;
    
    % parse training input into tree
    if ~isempty(index) 
        for l=1:size(good_bucks,1)
            cur_good_buck = good_bucks(l,1);
            cur_tree.parse(cur_good_buck{1});
        end
    end
    trees(1,k) = cur_tree;
end

end