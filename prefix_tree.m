classdef Prefix_tree < handle
    
    properties
        
        root_nodes = [];
        training_input = [];
        
    end
    
    methods
        
        function [node] = continue_input(obj, input)
            % Returns a single continuation node of an input sequence.
            cur_tree_nodes = obj.root_nodes;
            i = size(input,2);
            
            prev_node = Node.empty;
            while ~isempty(cur_tree_nodes)   
                if i < 1
                    break;
                end
                
                cur_tree_node = cur_tree_nodes(end);
                if cur_tree_node.is_equal(input(i))
                    % found match, move onto children + next input
                    prev_node = cur_tree_node;
                    cur_tree_nodes = cur_tree_node.children;
                    i = i - 1;
                else
                    cur_tree_nodes = cur_tree_nodes(1,1:end-1);
                end
            end
            
            if ~isempty(prev_node)
               contin_index = prev_node.pick_contin();
               node = Node(obj.training_input(contin_index), [], []);
            else
                % pick random root node to start again.
                i = randi(length(obj.root_nodes));
                node = obj.root_nodes(i);
            end
            
        end
        
        function [output] = generate(obj, input, len)
            % generates an output sequence of given length based on the
            % input.
            output(1,len) = Node;
            cur_input = input;
            for i = 1:len
                output(i) = obj.continue_input(cur_input); 
                cur_input = [cur_input, output(i)];
            end  
        end
        
        function [obj] = parse(obj, midi_input)
            % get prefixes from input
            prefix = [];
            overall = length(obj.training_input);
            obj.training_input = [obj.training_input, midi_input];

            if size(midi_input,2) > size(midi_input,1)
                midi_input = midi_input';
            end

            for i = length(midi_input)-1:-1:1
    
                contin_indices = ones(i,1) * i + 1 + overall;
                prefix = [midi_input(i:-1:1),contin_indices];

                new_nodes(size(prefix,1),1) = Node;
                for j = size(prefix, 1):-1:1
                    new_nodes(j).note_value = prefix(j,1);
                    new_nodes(j).add_contin(prefix(j,2));
                    if j < size(prefix, 1)
                       new_nodes(j).add_child(new_nodes(j+1));
                    end
                end
                
                obj.add_input(new_nodes(1));
                 clear new_nodes;
            end
        end

        function [obj] = add_input(obj, root_input)
            % add input to tree
            node_list = Node.empty;
            cur_nodes = obj.root_nodes;
            cur_input = root_input;
            i = 0;
            hit_loop = false;
            
            while cur_input.has_children
                
                i = i + 1;
                hit_loop = true;
                
                % if tree has no further nodes, add remaining input
                if isempty(cur_nodes)
                   if ~isempty(node_list)
                        node_list(end).add_child(cur_input);
                   else
                        obj.root_nodes = [obj.root_nodes, cur_input];
                   end 
                   break
                end
                
                for j = 1:length(cur_nodes)
                    
                    if cur_nodes(j).is_equal(cur_input)
                        node_list(i) = cur_nodes(j);
                        cur_nodes = cur_nodes(j).children;
                        break;
                    end
                   
                    if j == length(cur_nodes)
                        % add rest of input as chain of nodes
                        if ~isempty(node_list)
                            node_list(end).add_child(cur_input);
                        else
                            obj.root_nodes = [obj.root_nodes, cur_input];
                        end
                    end
                end
                
                cur_input = cur_input.children(1);
            end
            
            % handle case for remaining input has no children
                i = i + 1;
                for j = 1:length(cur_nodes)

                    if cur_nodes(j).is_equal(cur_input)
                        node_list(i) = cur_nodes(j);
                        break;                        
                    end

                    if j == length(cur_nodes)
                        % add rest of input as chain of nodes
                        if ~isempty(node_list)
                            node_list(end).add_child(cur_input);
                        else if ~hit_loop
                                % if root_input had no children, it's a
                                % new root node
                            obj.root_nodes = [obj.root_nodes, cur_input];
                            end
                        end
                    end
                end

            % add continuation indices to node_list
            for k = 1:length(node_list)
                node_list(k).add_contin(cur_input.contin_list(1));
            end
        end
        
    end
    
end