# commande pour parser xml via xpath perl ou xmllint --shell par exemple

# commande xmllint
cd
ls
cat
cat key[2]
cat *[position()<10]
xpath
help
pwd

# sur l'exemple xml AlbumData.xml de iPhoto
xpath .
xpath //root
xpath *
xpath *[position()<10]

xpath /plist/dict/array[1]/dict[4]/key[text()='AlbumName']/following::string[1]

xpath //key[text()='AlbumName']/following::string[1]/text()

xpath /plist/dict/array[1]/dict/key[text()='AlbumName']/following::string[1]/text()
xpath /plist/dict/array[1]/dict/key[text()='AlbumName']/following::string[1]/text()
