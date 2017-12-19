# basic-continuator
A basic implementation of Pachet's Continuator.

##Files of interest:
	live_demo.m - an example script for testing out the continuator
			* can generate example [input,continuation] midi files
			* includes example for generating plots for a dataset


	Prefix_tree.m - Data structure for the continuator's prefix tree. 
			* contains functions for parsing input sequences to trees
			* contains functions for generating new continued sequences of any length

	Node.m - the nodes of the prefix tree
			* holds properties for note_value, continuation lists, and a node's children list
			* includes isequal, that checks equality for nodes
			* this could be expanded to hold info for other midi properties like velocity/starttimes/etc.

	dataset/total_dataset.mat - The dataset we generated for our paper/presentation plots.
			* Can load this into matlab, to generate plots on your own

	plot_analysis.m - plots analysis data of any dataset
			* edit distance of continuation vs. truth
			* longest common subsequence of continuation vs. truth

	generate_dataset.m - script that generates dataset for given folder
			* Must give path to folder of midi files
			* creates the dataset based on found 4 bar midi section

	test_script.m - contains a few short examples
			* example for building prefix tree
			* example for generating continuation
			* example for generating continuation midi files