#!/bin/bash
while [ 1 ]
do
sukces="nie"
rozbite=""
klucz=""
czyjestwwikiquotes=""
czytaj=""
kluczsparsowanyDuzeLitery=""
ileslow=0
licznik=0
koncowequery=""
querydowgeta=""


cp odp_fin.json odp_bk.json
arecord -q -f cd -t wav -d 3 -D plughw -r 16000 proba.wav;
flac proba.wav -f --totally-silent --best --sample-rate 16000 -o proba.flac; 
wget --timeout=3 -O - -o /dev/null --post-file proba.flac --header="Content-Type: audio/x-flac; rate=16000" http://www.google.com/speech-api/v1/recognize?lang=pl >odp_fin.json;
rozbite=$(grep -Po '".*?"' <odp_fin.json) #usuwamy nawiasy sześcienne
echo $rozbite >odcz.txt #zapisujemy odpowiedź googla do pliku - separatorem jest spacja
klucz=$(awk -F\" '// {print $12}' odcz.txt | tr -d '"') # tutaj jest rozpoznany tekst z Googla, ale nie po spacji jako separatorze, tylko po cudzysłowie. Tekst, który chcemy jest na pozycji 12.
ileslow=$(echo "$klucz" | wc -w)
echo "Rozpoznano $ileslow slow"

if [ "$ileslow" -gt 0 ]; then

	for (( licznik=$ileslow; licznik>=1; licznik-- ))
	do
		mplayer words_0$[ ( $RANDOM % 5 )  + 1 ].mp3
		echo "Szukamy słów $licznik - literowych"
		tekst_query=$(./permutacje2 $klucz $licznik)
		echo $tekst_query
		link_do_wgeta="http://pl.wikiquote.org/w/api.php?action=query&titles=$tekst_query&format=json&redirects"
		# echo $link_do_wgeta
		wget --timeout=3 -q -O pobrany.json $link_do_wgeta
		cat pobrany.json | ./jq '.query.pages' | ./jq 'keys' | sed 's/"//g' | sed 's/,//g' | sed 's/^  //g' | awk '!/\[|\]|^-/'>lista_kluczy.txt
		liczba_trafien=$(cat lista_kluczy.txt | wc -l)
		echo "Rozpoznano $liczba_trafien trafien"
		if [ "$liczba_trafien" -gt 0 ]; then
			echo  "Mamy ptaszka!"
			idstrony=$(shuf -n 1 lista_kluczy.txt)
			koncowequery=$(cat pobrany.json | ./jq -M '.query.pages["'${idstrony}'"].title' | sed 's/"//g')
			sukces="tak"			
			echo "Otwieramy hasło $koncowequery"
			break
		fi
	done

	if [ "$sukces" == "tak" ]; then
		querydowgeta=$(echo $koncowequery | sed 's/ /_/g' | sed 's/?/%3F/g' | tr -d "\r\n")
		wget --timeout=3 -o wgetlog.txt -O wikitekst.txt http://pl.wikiquote.org/wiki/$querydowgeta?action=raw #pobierz wikitekst oraz zapisz log operacji wgeta
		
		echo "========================================="
		
			# echo Lista cytatów dla $koncowequery:
			# awk '/^* /' wikitekst.txt >lista_cytatow.txt
			awk '/^\* /' wikitekst.txt | sed 's/*/ /g' | sed 's/<br \/>/ /g' >lista_cytatow.txt # najpierw szukamy wszystkich linijek zaczynających się od gwiazdki i spacji (to przez awk). Następnie sed zastępuje ciąg <br /> spacją i usuwamy gwiazdki z początku linijek. Rezultat zapisywany jest do pliku.
		
			czytaj=$(shuf -n 1 lista_cytatow.txt | cut -c1-99) # losowo wybiera jedną linijkę
			echo $czytaj
		
			# milena_say $czytaj
			# echo $czytaj | iconv -f UTF8 -t ISO_8859-2 | festival --tts --language polish
			wget -q -U Mozilla -O czytany.mp3 "http://translate.google.com/translate_tts?ie=UTF-8&tl=pl&q=$czytaj" #pobiera plik mp3 z google translate
			mplayer czytany.mp3 #odgrywa
		# fi
	fi
fi

done
