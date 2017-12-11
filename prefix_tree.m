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
            
            while ~isempty(cur_input)
                i = i + 1;
                 
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
                        
                        if ~isempty(cur_input.children)
                            cur_input = cur_input.children(1);
                        else
                            cur_input = Node.empty;
                        end
                        break;
                    end
                   
                    if j == length(cur_nodes)
                        % add rest of input as chain of nodes
                        if ~isempty(node_list)
                            node_list(end).add_child(cur_input);
                        else
                            obj.root_nodes = [obj.root_nodes, cur_input];
                        end
                        
                        cur_input = Node.empty;
                    end
                end
            end

            % add continuation indices to node_list
            for k = 1:length(node_list)
                node_list(k).add_contin(root_input.contin_list(1));
            end
        end
        
        function [] = draw_tree(obj)
            space = '    ';
            note_space = '   ';
            slash = '|';
            back_slash = '\';
            
            nodes = obj.root_nodes;
            children = [];
            
            % draw root nodes
            str_roots = '';
            for i=1:size(nodes, 2) 
                cur_root = nodes(i);
                str_roots = strcat(str_roots,num2str(cur_root.note_value));
                str_roots = strcat(str_roots,{note_space}); 
                for d=1:size(cur_root.children, 2)
                    if (d ~= 1) 
                        str_roots = strcat(str_roots,{note_space}); 
                    end
                end 
            end
            disp(str_roots);
            
            str_lines = '';
            str_nodes = '';
            
            while (~isempty(nodes))
                for index = 1:size(nodes, 2)
                    cur_node = nodes(index);

                    % draw lines between children and cur_node
                    for l=1:size(cur_node.children,2)
                        if (l == 1)
                            str_lines = strcat(str_lines, slash);
                        else
                            str_lines = strcat(str_lines, back_slash);
                        end

                        str_lines = strcat(str_lines, {space}); 
                        
                        for d=1:size(cur_node.children(l).children, 2)
                            if (d ~= 1) 
                                str_lines = strcat(str_lines,{space}); 
                            end
                        end 
                    end

                    % draw children
                    for c=1:size(cur_node.children, 2)
                        cur_child = cur_node.children(c);
                        str_nodes = strcat(str_nodes, num2str(cur_child.note_value));
                        str_nodes = strcat(str_nodes, {note_space}); 
                        children = [children, cur_child];
                        for d=1:size(cur_child.children, 2)
                            if (d ~= 1) 
                                str_nodes = strcat(str_nodes,{note_space}); 
                            end
                        end 
                    end

                     if (isempty(cur_node.children))
                        % no children, but add a space
                        str_nodes = strcat(str_nodes, {note_space}); 
                        str_lines = strcat(str_lines, {space}); 
                    end

                    if (index == size(nodes, 2))
                        % Completed single row, move on to children
                        nodes = children;
                        children = [];
                        disp(str_lines);
                        disp(str_nodes);
                        str_lines = '';
                        str_nodes = '';
                    end
                end
            end
        end    
    end
end