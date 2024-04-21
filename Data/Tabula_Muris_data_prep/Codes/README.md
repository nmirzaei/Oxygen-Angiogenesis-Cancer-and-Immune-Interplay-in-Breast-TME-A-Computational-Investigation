# Oxygen-Angiogenesis-Cancer-and-Immune-Interplay-in-Breast-TME-A-Computational-Investigation


##Signature matrix preparation

For creating a signature matrix using CiberSortx, you need to have access to single-cell RNA sequencing data (scRNA-seq). 

###Human data: 
you can probably skip this step since CiberSortx has a very robust signature matrix called LM22 which can be used to get the immune cell’s fraction from bulk RNA-seq.

###Mouse data: 
Since we cannot use LM22 for mice we need to create our own signature matrix. A good resource would be the publicly available Tabula Muris database. See link. They have an atlas of scRNA-seq for all important mouse organs and tissues. This data consists of two sets. Data acquired from FACS and data acquired from Droplets. Based on their paper, the former shows a better variety of cells. Also, it is already given as counts, unlike the droplet data, which is a barcode, genes, and matrix format.  See the appendix for learning how to change the droplet data into count data. 
