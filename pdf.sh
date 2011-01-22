cd /Applications/pdfsam-2.1.0.app/Contents/Resources/Java/bin 
l="a"
path="/Users/bilalh/Uni/CS/CS2002/Lectures/arch/spilt/"
for n in {3..3}; do
	for i in ${path}/${l}${n}/*.pdf; do 
		sh run-console.sh -f $i -o "${path}/${l}${n}" -s BURST split
	done
done

