import pandas
from csv import DictReader

col = pandas.read_csv('Column.txt',header=None)
header =['Genes']+DictReader(open('header.csv', 'r')).fieldnames
df = pandas.read_csv('Target-scRef.csv')
selected_col = col.iloc[:, 0]
df.insert(0,column="Genes",value=selected_col )
df.columns = header

df.to_csv('Target-scRef-final.txt',sep='\t',index=False)
