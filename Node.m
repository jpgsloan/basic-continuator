classdef Node < handle
    
    properties
        
        note_value;
        contin_list = [];
        children = [];
        
    end
    
    methods
        
        % initializers
        
        function obj = Node(varargin)
            
            if nargin == 3
                obj.note_value = varargin{1};
                obj.contin_list = varargin{2};
                obj.children = varargin{3};
            else
                obj.note_value = -1;
                obj.contin_list = [];
                obj.children = [];
            end
            
        end
        
%         function obj = Node(note_value, contin_list, children)
%             
%             obj.note_value = note_value;
%             obj.contin_list = contin_list;
%             obj.children = children;
%             
%         end
        
        % equality testing function
        
        function [comp] = is_equal(obj, other_node)
           
            comp = (obj.note_value == other_node.note_value);
            
        end
        
        % random continuation function
        
        function [next] = pick_contin(obj)
           
            i = randi(length(obj.contin_list));
            next = obj.contin_list(i);
            
        end
        
        % add to continuation list
        
        function [obj] = add_contin(obj, contin)
            
           obj.contin_list = [obj.contin_list, contin]; 
            
        end
        
        % add child function
        
        function [obj] = add_child(obj, child_node)
            
            obj.children = [obj.children, child_node];
            
        end
        
        % has children function
        
        function [has] = has_children(obj)
           
            has = ~isempty(obj.children);
            
        end
        
    end
    
end