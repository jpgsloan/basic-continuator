function [row_size] = cell_size_row(cell)

if isempty(cell)
    row_size = 0;
else
    row_size = size(cell,1);
end

end