clc
clear

k=1;

%These are the available tissue names as they show in the annotations_Facs
Tissue_names = ["Bladder","Colon","Fat",...
    "Heart", "Kidney", "Liver", "Lung", "Mammary", "Marrow", "Muscle",...
    "Pancreas", "Skin", "Spleen", "Thymus", "Tongue", "Trachea"];

%These are the cells we are interested in according to annotations_Facs
%Formatted in Matlab 
Target_cells = ["basalCell", "endothelialCell",...
    "stromalCell","mesenchymalStemCellOfAdipose","luminalEpithelialCellOfMammaryGland"];

%Read the gene symbols
Genes = readtable('Genes.csv')
h=[];
for j=1:size(Tissue_names,2)
    j
    %Read the scRef file for each tissue
    opts = detectImportOptions(Tissue_names(j)+"-scRef.csv",'NumHeaderLines',0);
    A = readtable(Tissue_names(j)+"-scRef.csv",opts);

    for i=2:size(A,2)
        %Check the sample name for the column to see if it is among our
        %targets.  
        str = A.Properties.VariableNames(i);
        underlineLocations = find(char(str) == '_', 2, 'first');
        
        %If the column header has underscore is because Matlab doesn't like
        %duplicates. But for Cibersortx we can have many dublicate cell names
        %So the following fixes this. For example macrophage_17 will be 
        %turned back into macrophage.
        if size(underlineLocations,2)~=0
            str1 = char(str);
            str1 = str1(1:underlineLocations-1);
        else
            str1 = char(str);
        end
    
        %If the column header is one of our target cells then we add it 
        if ismember(str1,Target_cells)==1
            %Adding the header of the column to the list h
            h{end+1}=str1;
            %Getting the column values
            M_temp = A.(char(str));  

            %Checking for Nan values.
            %Note: NaN values appear because some scRefs get imported into
            %Matlab as string arrays and some as numerics.
            %If they are strings then str2double(M_temp)) produces a
            %numeric array. If they are numerics to begin with it will give
            %NaN.
            hasNaN = any(isnan(str2double(M_temp)));

            %checking for NaNs and taking the proper action accordingly
            if hasNaN
                M(:,k)=M_temp;
            else
                M(:,k) = str2double(M_temp);
            end
            % Checking for empty arrays
            if size(M(:,k),2)==0
                disp('The array is empty.');
            end
            k=k+1;
        end

    end
end
%Writting the header and the values into csv files
M1=array2table(M);
cell2csv('header.csv',h);
writetable(M1,'Target-scRef.csv')
