function solution = read_solution_from_VTU(path, filename)
% Input:
% - path:
% - filename: without extension
% Output:
% - solution: structure with solution data
%    solution{1} has data points, number of components = 3
%    solution{2} has data cell connectivity
%    solution{3} has data cell offsets
%    solution{4} has data cell types
%    solution{5} has data point data f_17 (solution)

disp(strcat('Reading file ', filename, '.vtu'))
fid_r1 = fopen(strcat(path + filename + '.vtu')); % info about file
tline = fgetl(fid_r1); % next line

contador = 1;
solution = {};
while ischar(tline)
    tline = fgetl(fid_r1); % next line
    if tline==-1 % is empty
        break
    end
    if contains(tline,'format="ascii">')==1 % VTU en formato ascii, los datos lo tienen...
        % comenzar a leer despues de format="ascii">
        %p = textscan(tline,'%f','delimiter', '  ');
        format = '';
        if contains(tline, 'Float64')
            format = '%f';
        end
        if contains(tline, 'UInt32')
            format = '%d32';
        end
        if contains(tline, 'UInt8')
            format = '%d8';
        end
        
        p = textscan(tline, format,'CommentStyle', {'<', '>'},'delimiter', ' ', 'MultipleDelimsAsOne', 1);
        solution{contador} = p{1}; % solution changes size over loop iteration.... 
        contador = contador +1;
    end
end
fclose(fid_r1);

end