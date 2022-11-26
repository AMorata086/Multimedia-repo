import requests
import json
from bs4 import BeautifulSoup
import pandas as pd


usecolsA = [1]
required_df = pd.read_excel('imdbtitles.xlsx', usecols = usecolsA, skiprows = 1 )
excelL = required_df.values.tolist()
output = open('movies.json', 'a', encoding='utf8')
dictList = []
#print(len(required_df))
#print(len(excelL))
for i in excelL:
    dictMovie = {}
    print(i[0])
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102'}
    r = requests.get(i[0],headers=headers)
    r.encoding
    #r = requests.get(i[0]+'/reference')
    imdb= BeautifulSoup(r.text, 'html.parser')
    req = requests.get(i[0]+'/synopsis?ref_=tt_stry_pl')
    sinopsis_url = BeautifulSoup(req.text, 'html.parser')
    urls = imdb.select('a[href]')
    urls_list = [urls.string for urls in urls]
    title = imdb.select('h1.sc-b73cd867-0')[0].text.strip()
    year = imdb.select('span.sc-8c396aa2-2')[0].text.strip()
    director = imdb.select('a.ipc-metadata-list-item__list-content-item--link')[0].text.strip()
    guionist = imdb.select('a.ipc-metadata-list-item__list-content-item--link')[1].text.strip()
    actor = imdb.select('a.sc-bfec09a1-1')
    genre = []
    genre_list = []
    actor_list = []
    summary = imdb.select('span.sc-16ede01-2')[0].text.strip()
    max = len(sinopsis_url.select('li.ipl-zebra-list__item'))
    sinopsis = sinopsis_url.select('li.ipl-zebra-list__item')[max-1].text.strip()
    if("It looks like we don't have a Synopsis" in sinopsis):
        sinopsis = ""
    summary = str(summary).replace("Read all","")
    genre = imdb.select('span.ipc-chip__text')
    score = imdb.select('span.sc-7ab21ed2-1')[0].text.strip()
    for j in genre:
        genre_list.append(j.text.strip())
    for j in actor:
        actor_list.append(j.text.strip())
    dictMovie["title"] = title
    dictMovie["year"] = year
    dictMovie["genres"] = genre_list
    dictMovie["actors"] = actor_list
    dictMovie["director"] = director
    dictMovie["guionist"] = guionist
    dictMovie["score"] = score
    dictMovie["summary"] = summary
    dictMovie["sinopsis"] = sinopsis
    dictList.append(dictMovie)
json.dump(dictList, output, ensure_ascii=False)
print(output)
    