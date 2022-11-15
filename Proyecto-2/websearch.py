import requests
from bs4 import BeautifulSoup
import pandas as pd

usecolsA = [1]
required_df = pd.read_excel('imdbtitles.xlsx', usecols = usecolsA, skiprows = 1 )
excelL = required_df.values.tolist()
print(len(required_df))
print(len(excelL))
for i in excelL:
    print(i[0])
    r = requests.get(i[0])
    print(r)
