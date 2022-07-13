import json
from bs4 import BeautifulSoup

with open('raw_data.txt', encoding='utf-8') as f:
    html_data = f.read()

soup = BeautifulSoup(html_data, 'html.parser')
metro_lines = {}
color_map = {'red': 'M1', 'blue': 'M2', 'green': 'M3', 'yellow': 'M4'}

for html_stop in soup.find_all('li'):
    stop_name = html_stop.text.replace('&nbps;', '').strip()
    #print(stop_name)
    while html_stop.i is not None:
        line_tag = html_stop.i.extract()
        if 'class' in line_tag.attrs:
            for line in line_tag.attrs['class']:
                if str(line).find('-link') > -1:
                    line = str(line).replace('-link', '')
                    line = color_map[line]
                    #print(line)
                    if line not in metro_lines:
                        metro_lines[line] = []
                    metro_lines[line].append(stop_name)
    #print(html_stop.text.replace('&nbsp;', '').strip())
#print(metro_lines)
for line, stops in metro_lines.items():
    print(line, stops)

# print(soup)

# for row in rows:
#     print(row)
#     break

with open("metro_lines.json", "w", encoding='utf8') as outfile:
    json.dump(metro_lines, outfile, ensure_ascii=False)
