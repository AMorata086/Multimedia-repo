import requests
import json
from bs4 import BeautifulSoup
import pandas as pd

usecolsA = [1]
required_df = pd.read_excel('imdbtitles.xlsx', usecols=usecolsA, skiprows=1)
excelL = required_df.values.tolist()
output = open('movies.json', 'a', encoding='utf8')
output.write('[')
backup_fd = open('backup_movies.json', 'w', encoding='utf8')
dictList = []

# print(len(required_df))
# print(len(excelL))

skip_count = 0

for i in excelL:
    if skip_count < 8222:
        skip_count += 1
        continue
    dictMovie = {}
    print(i[0])
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102'}
    try:
        r = requests.get(i[0], headers=headers)
        r.encoding
        # r = requests.get(i[0]+'/reference')
        imdb = BeautifulSoup(r.text, 'html.parser')
        req = requests.get(i[0]+'/synopsis?ref_=tt_stry_pl')
        sinopsis_url = BeautifulSoup(req.text, 'html.parser')
    except:
        json.dump(dictList, backup_fd, ensure_ascii=False, indent=4)
        continue
    urls = imdb.select('a[href]')
    urls_list = [urls.string for urls in urls]
    try:
        title = imdb.select('h1')[0].text.strip()
    except:
        title = ""
    try:
        year = imdb.select('span.sc-8c396aa2-2')[0].text.strip()
    except:
        year = ""
    try:
        director = imdb.select(
            'a.ipc-metadata-list-item__list-content-item--link')[0].text.strip()
    except:
        director = ""
    try:
        guionist = imdb.select(
            'a.ipc-metadata-list-item__list-content-item--link')[1].text.strip()
    except:
        guionist = ""
    try:
        actor = imdb.select('a.sc-bfec09a1-1')
    except:
        actor = ""
    genre = []
    genre_list = []
    actor_list = []
    try:
        summary = imdb.select('span.sc-16ede01-2')[0].text.strip()
        summary = str(summary).replace("Read all", "")
    except:
        summary = ""
    try:
        max = len(sinopsis_url.select('li.ipl-zebra-list__item'))
        sinopsis = sinopsis_url.select(
            'li.ipl-zebra-list__item')[max-1].text.strip()
        if ("It looks like we don't have a Synopsis" in sinopsis):
            sinopsis = ""
    except:
        sinopsis = ""

    try:
        score = imdb.select('span.sc-7ab21ed2-1')[0].text.strip()
    except:
        score = ""
    try:
        genre = imdb.select('span.ipc-chip__text')
        for j in genre:
            genre_list.append(j.text.strip())
    except:
        genre_list.append("")
    try:
        for j in actor:
            actor_list.append(j.text.strip())
    except:
        actor_list.append("")

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
    json.dump(dictMovie, output, ensure_ascii=False, indent=4)
    output.write(',')


output.write(']')
output.close()
backup_fd.close()
