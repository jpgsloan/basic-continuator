function [] = plot_analysis(total_dataset)

% PLOT EDIT DISTANCE
edit_dists = total_dataset(:,7);
orig_input = total_dataset(:,5);
edit_truth = total_dataset(:,9);
edit_truth = cellfun(@identity_cell,edit_truth);

% average across the 10 continuations per input
avg_edits = cellfun(@mean,edit_dists);

% divide each average edit dist by input length (also = contin length)
input_sizes = cellfun(@cell_size_row,orig_input);
norm_edits = avg_edits ./ input_sizes;

% calculate the overall average value of edit dist
overall_avg_edit = sum(norm_edits) / size(norm_edits,1);

% plot raw data
figure;
scatter(avg_edits,[1:length(avg_edits)])
ylabel('Test Sample');
xlabel('Average Edit Distance from Truth');
title('Average Edit Distance')

% plot avg contin - truth
figure;
scatter(norm_edits,[1:length(norm_edits)])
ylabel('Test Sample');
xlabel('Average Edit Distance Ratio from Truth');
title('Average Edit Distance Ratio')

% plot truth - input
figure;
hist(edit_truth)
ylabel('Test Sample');
xlabel('Average Edit Distance of Truth vs Input');
title('Average Edit Distance of Truth vs Input')

% PLOT LONGEST COMMON SUBSEQUENCE

long_subs = total_dataset(:,8);
avg_subs = cellfun(@mean,long_subs);
norm_subs = avg_subs ./ input_sizes;

% histogram of raw data
figure;
hist(avg_subs);
ylabel('Quantity of Test Samples');
xlabel('Average Longest Common Subsequence');
title('Average Longest Common Subsquence')

% histogram of ratio of LCS / input size (essentially percent of
% continuation contained in truth
figure;
hist(norm_subs);
ylabel('Quantity of Test Samples');
xlabel('Average Longest Common Subsequence Ratio');
title('Average Longest Common Subsquence Ratio')

end