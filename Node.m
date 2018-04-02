classdef Node < handle
    
    properties
        children = [];
        
        % list of possible continuation nodes.
        contin_list = [];
        
        % times from last note in node to each continuation.
        contin_timing = []; 
        
        % matrix of midi notes Nx8 (see Ken Schutte for col values) 
        full_midi = []; 
    end
    
    methods      
        % initializer
        function obj = Node(varargin)
            if nargin == 1
                obj.full_midi = varargin{1};
            elseif nargin == 4
                obj.full_midi = varargin{1};
                obj.children = varargin{2};
                obj.contin_list = varargin{3};
                obj.contin_timing = varargin{4};
            else
                obj.full_midi = [];
                obj.contin_list = [];
                obj.children = [];
                obj.contin_timing = [];
            end
        end
        
        % check if two nodes are equal
        function [comp] = is_equal(obj, other_node)
            
            % TODO: must update to check if note lists are equal.
            obj_note_values = obj.note_values();
            other_note_values = other_node.note_values();
            comp = isequal(obj_note_values, other_note_values);
        end
        
        % pick from continuation list at random 
        function [next, timing] = pick_contin(obj)
            i = randi(length(obj.contin_list));
            next = obj.contin_list(i);
            timing = obj.contin_timing(i);
        end
        
        % add to continuation list
        function [obj] = add_contin(obj, contin, timing)
           obj.contin_list = [obj.contin_list, contin]; 
           obj.contin_timing = [obj.contin_timing, timing];
        end
        
        % add child node
        function [obj] = add_child(obj, child_node)
            obj.children = [obj.children, child_node];
        end
        
        function [has] = has_children(obj)
            has = ~isempty(obj.children);
        end
        
        function[note_values] = note_values(obj)
            if ~isempty(obj.full_midi) 
                note_values = obj.full_midi(:,3);
            end
        end
    end 
end