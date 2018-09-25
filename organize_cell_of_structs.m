function o=organize_cell_of_structs(cell_of_structs)
%converts a cell array of structures into a structure of vectors
ff=fields(cell_of_structs);
for kk=1:length(ff)
    o.(ff{kk})=[cell_of_structs.(ff{kk})];
end