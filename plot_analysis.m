function [] = plot_analysis(total_dataset)

edit_dists = total_dataset(:,7);
orig_input = total_dataset(:,5);

avg_edits = cellfun(@mean,edit_dists);

input_sizes = cellfun(@cell_size_row,orig_input);

norm_edits = avg_edits ./ input_sizes;
overall_avg_edit = sum(norm_edits) / size(norm_edits,1);

figure;
scatter(norm_edits,[1:length(norm_edits)])
ylabel('Test Sample');
xlabel('Average Edit Distance Ratio from Truth');
title('Average Edit Distance Ratio')

% average longest subsequence
figure;
long_subs = total_dataset(:,8);
avg_subs = cellfun(@mean,long_subs);

norm_subs = avg_subs ./ input_sizes;

hist(norm_subs);
ylabel('Quantity of Test Samples');
xlabel('Average Longest Common Subsequence Ratio');
title('Average Longest Common Subsquence Ratio')

end