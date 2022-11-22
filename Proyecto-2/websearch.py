import requests
import json
from bs4 import BeautifulSoup
import pandas as pd


usecolsA = [1]
required_df = pd.read_excel('imdbtitles.xlsx', usecols = usecolsA, skiprows = 1 )
excelL = required_df.values.tolist()
#print(len(required_df))
#print(len(excelL))
for i in excelL:
    dictMovie = {}
    print(i[0])
    r = requests.get(i[0]+'/reference')
    print(r)
    imdb= BeautifulSoup(r.text, 'html.parser')
    req = requests.get(i[0]+'/synopsis?ref_=tt_stry_pl')
    print(req)
    sinopsis_url = BeautifulSoup(req.text, 'html.parser')
    urls = imdb.select('a[href]')
    urls_list = [urls.string for urls in urls]
    #title = imdb.select('h1.sc-b73cd867-0')[0].text.strip()
    title = imdb.select('h3')[0].text.strip()
    titulo = title.split("  ")
    titulo = titulo[0].strip()
    print(titulo)
    year= imdb.select('span.titlereference-title-year')[0].text.strip()
    year = year.replace('(','')
    year = year.replace(')','')
    print(year)
    #director = imdb.select('a.ipc-metadata-list-item__list-content-item--link')[0].text.strip()
    director = imdb.select('li.ipl-inline-list__item').text.strip()
    print(director)
    guionist = imdb.select('a.ipc-metadata-list-item__list-content-item--link')[1].text.strip()
    actor = imdb.select('a.sc-bfec09a1-1')
    genre = []
    genre_list = []
    actor_list = []
    sinopsis = sinopsis_url.find("li", {"id": "synopsis-py5253095"})
    #sinopsis = sinopsis_url.select('li.ipl-zebra-list__item.synopsis-py5253095')
    genre = imdb.select('span.ipc-chip__text')
    score = imdb.select('span.sc-7ab21ed2-1')[0].text.strip()
    for j in genre:
        genre_list.append(j.text.strip())
    for j in actor:
        actor_list.append(j.text.strip())
    dictMovie["title"] = title
    dictMovie["genres"] = genre_list
    dictMovie["actors"] = actor_list
    dictMovie["director"] = director
    dictMovie["guionist"] = guionist
    dictMovie["score"] = score
    #print(title)
    #print(genre_list)
    #print(actor_list)
    #print(director)
    #print(guionist)
    #print(score)
    #print(type(sinopsis))
    #print(urls_list)
    print(dictMovie)
    
