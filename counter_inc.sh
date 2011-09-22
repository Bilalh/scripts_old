file='/Users/bilalh/Desktop/_counter' 
if [ -f "$file" ]; then  
	num=$(echo \"1+$(cat "$file")\" | bc); 
	echo $num | bc > "$file"; 
else 
	echo '0' > "$file";  
fi