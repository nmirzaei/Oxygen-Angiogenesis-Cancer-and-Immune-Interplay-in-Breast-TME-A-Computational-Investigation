# Oxygen-Angiogenesis-Cancer-and-Immune-Interplay-in-Breast-TME-A-Computational-Investigation


## Signature matrix preparation

For creating a signature matrix using CiberSortx, you need to have access to single-cell RNA sequencing data (scRNA-seq). 

### Human data: 
you can probably skip this step since CiberSortx has a very robust signature matrix called LM22 which can be used to get the immune cell’s fraction from bulk RNA-seq.

### Mouse data: 
Since we cannot use LM22 for mice we need to create our own signature matrix. A good resource would be the publicly available Tabula Muris database. See link. They have an atlas of scRNA-seq for all important mouse organs and tissues. This data consists of two sets. Data acquired from FACS and data acquired from Droplets. Based on their information, the former shows a better variety of cells. Also, it is already given as counts, unlike the droplet data, which is in a barcode, genes, and matrix format. 

For the following sections we assume we are using the FACS counts from Tabula Muris.

## Step 1: Create a single-cell reference file from a tissue count file

For this step, we only need to run the Python file scRef_creator.py (found in Data/Tabula_Muris_data_prep/Codes), from where the count files are located. You need to input the tissue name before the code starts preparing the scRefs.

The python file reads the (trimmed) annotation file and replaces the obscure sample IDs in the counts files with cell type names. 

#### NOTE: The trimmed annotation file (found in Data/Tabula_Muris_data_prep/Other_files) is acquired by deleting extra columns from the original one. For a better understanding, just compare it with its original. 

## Step 2: Creating a target single-cell RNA reference from the tissue scRefs

After creating sc-Ref files for all the count files. Then we can use the Matlab code combine.m (found in Data/Tabula_Muris_data_prep/Codes) to search through the tissue-specific scRefs we created in the previous step and combine their information based on the target cells. 

#### Note: There is an input file Genes.csv (found in Data/Tabula_Muris_data_prep/Other_files) which contains the left-most column (Genes) of any of the scRef files (since they are all the same). We also make sure we delete the header “Genes” from it. So the column should start with the first gene symbol.

## Step 3: Creating the Target scRef file for CiberSortx

Once the Matlab code is done, we need to run one last Python code, cvs_fixer.py (found in Data/Tabula_Muris_data_prep/Codes), to prepare the file for Cibersortx. For this to run you need to use the input file Column.txt (found in Data/Tabula_Muris_data_prep/Other_files) which is basically the same as Genes.csv but some entries are formatted. The formatting is done because Excel turns some gene names such as Sept1 or March10 into dates. So, we fix those from the Genes files and save them into Column.txt so that the format stays and doesn’t change to date again.
After running this file you get the Total-scRef-final.txt, which will be fed to Cibersortx.

## Step 4: Creating the gene signature matrix by Cibersortx

Upload the Total-scRef-final.txt file on Cibersortx and then go to “Create Signature Matrix” module. Click on “Custom” and then “scRNA-seq” button. From the first drop-down menu choose your txt file you just uploaded. Write a name for your output in “Custom sig file name*” box, choose a lower min. expression value (e.g. 0.35) and hit run. Once it is done you should have signature matrix and a couple other files. The most important file besides the signature matrix is the sourceGEP. 

## Step 5: Impute cell fractions using your signature matrix

Upload your bulk RNA-seq mixture file. Go to “Impute cell fractions” on Cibersortx and click on “Custom” again. From “Signature matrix file*” drop-down pick the signature matrix you created in the last step. From the second drop-down pick your mixture file. Then Enable Batch Correction. Here since you have used your own sourceGEP you can use B-mode, choose your GEP file you created in step 4 uncheck the normalization and hit run. 

#### Note: These steps were done for acquiring the signature matrix and cells fractions of non-immune cells. For the immune cells we used the already available immgen signatures.
