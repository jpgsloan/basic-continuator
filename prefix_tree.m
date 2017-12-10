classdef Prefix_tree < handle
    
    properties
        
        root_nodes = [];
        training_input = [];
        
    end
    
    methods
    
        % get prefixes from input
        
        function [obj] = parse(obj, midi_input)

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
        
        % add input to tree
        
        function [obj] = add_input(obj, root_input)
            
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
            
            % handle case for root_input had no children
            if ~hit_loop
                i = 1;
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
            end

            % add continuation indices to node_list
            for k = 1:length(node_list)
                node_list(k).add_contin(cur_input.contin_list(1));
            end
        end
        
    end
    
end