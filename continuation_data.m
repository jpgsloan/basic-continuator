function [output_data] = continuation_data(buckets, bools, trees, filename)

output_data = cell(0,6);
for m=1:size(trees,2)
    % loop through buckets of tree's corresponding track
    num_buckets = size(buckets(:,m),1);
    n = num_buckets;
    while n > 1     
        cur_buck_num = num_buckets - n + 1;
        if bools(cur_buck_num,m)
            % found good bucket                  
            if bools(cur_buck_num + 1,m)
                % also has good neighbor bucket/valid ground truth continuation. 
                % add cur buck to list and skip next bucket, avoids redundancy.
                cur_bucket = buckets(cur_buck_num,m);             
                cur_truth = buckets(cur_buck_num + 1,m);
                
                % get current track's tree
                cur_tree = trees(1,m);
                
                % extract input bucket as notes
                input = cur_bucket{1};
                bucket_notes = bucket2notes(input);
                len_buck_notes = size(bucket_notes,2);
                
                % convert bucket notes to tree nodes
                bucket_nodes = notes2nodes(bucket_notes);
                
                % generate 10 continuations with current track's tree
                contins = cell.empty(0,10);
                for x=1:10
                    cur_contin = cur_tree.generate_notes(bucket_nodes, len_buck_notes);
                    contins(1,x) = {cur_contin};
                end          
                
                % create 1x6 array of output data
                data_row = [filename, m, cur_buck_num, cur_bucket, cur_truth, {contins}];
                output_data = [output_data; data_row];
                
                n = n - 1;
            end
        end
        n = n - 1;
    end
end

end