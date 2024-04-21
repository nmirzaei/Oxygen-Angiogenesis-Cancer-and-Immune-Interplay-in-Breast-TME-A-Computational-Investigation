% Function to write cell array to CSV file
function cell2csv(fileName, cellArray)
    fid = fopen(fileName, 'w');
    [rows, cols] = size(cellArray);

    for row = 1:rows
        for col = 1:cols
            if isnumeric(cellArray{row, col})
                fprintf(fid, '%g', cellArray{row, col});
            elseif ischar(cellArray{row, col})
                fprintf(fid, '"%s"', cellArray{row, col});
            end

            if col < cols
                fprintf(fid, ',');
            end
        end
        fprintf(fid, '\n');
    end

    fclose(fid);
end