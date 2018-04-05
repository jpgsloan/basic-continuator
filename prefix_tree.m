classdef Prefix_tree < handle
     
    properties       
        root_nodes = [];
        
        % training input is a cell array of midi note matrices. For
        % example, a 3 note chord will be a 3x8 note matrix stored at a
        % given index of the training_input cell array.
        training_input = [];
    end
    
    methods
        function [node, timing] = continue_input(obj, input)
            % Returns a single continuation node of an input sequence.
            if isempty(obj.root_nodes)
                node = Node.empty;
                return;  
            end
            
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
               [contin_index, timing] = prev_node.pick_contin();
               node = Node(obj.training_input{contin_index}, [], [], []);
            else
                % pick random root node to start again.
                i = randi(length(obj.root_nodes));
                node = obj.root_nodes(i);
                timing = 0.1; % TODO: this maybe could be average
                             %       of distances seen in input.
            end
            
        end
        
        function [output_nodes] = generate(obj, input, len)
            % generates an output sequence of given length based on the
            % input.
            output_nodes(1,len) = Node;
            cur_input = input;
            for i = 1:len
                new_node = obj.continue_input(cur_input);
                if ~isempty(new_node)
                    output_nodes(i) =  new_node;
                else
                    output_nodes(i) = Node();
                end
                
                cur_input = [cur_input, output_nodes(i)];
            end  
        end 
        
        function [output_values] = generate_notes(obj, input, len)
            % generates an output sequence of midi note values given length based on the
            % input.
            out_nodes = generate(obj,input,len);
            
            output_values = cell.empty(0,size(out_nodes,2));
            for i = 1:size(out_nodes,2)
                cur_node = out_nodes(i);          
                output_values(1,i) = {cur_node.note_values()};
            end  
        end
        
        function [output_midi] = generate_midi(obj, input, len)
            % generates continuation of given length in midi note format.
            output_midi = [];
            cur_input = input;
            overall_time = 0;
            for i = 1:len
                [new_node, delay] = obj.continue_input(cur_input);
                if isempty(new_node)
                    disp('Error: no continuation generated.')
                    continue
                end
                % add in delay previously seen before continuation.
                
                
                % append midi notes normalized to start at overall
                % running time.
                [norm_midi, end_time] = new_node.normalized_timing(overall_time + delay);
                output_midi = [output_midi; norm_midi];
                    
                % increment overall time
                overall_time = end_time;

                cur_input = [cur_input, new_node];
            end  
        end 
        
        function [obj] = parse(obj, midi_input)
            prefix = [];
            chords = group_chords(midi_input);
            overall = size(obj.training_input,2);
            obj.training_input = [obj.training_input, chords];
            
            if size(chords,2) > size(chords,1)
                chords = reshape(chords,[length(chords),1]);
            end
            
            for i = size(chords,1)-1:-1:1
                contin_index = i + 1 + overall;
                prefix = chords(i:-1:1);
                last_notes = chords{i};
                
                contin_timing = continuation_timing(...
                    last_notes, obj.training_input{contin_index});
                
                new_nodes(size(prefix,1),1) = Node;
               
                for j = size(prefix, 1):-1:1
                    full_midi = prefix(j,1);
                    new_nodes(j).full_midi = full_midi{1};
                    new_nodes(j).add_contin(contin_index,contin_timing);
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
                node_list(k).add_contin(root_input.contin_list(1), root_input.contin_timing(1));
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