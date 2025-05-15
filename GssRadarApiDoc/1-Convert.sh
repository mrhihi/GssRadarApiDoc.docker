
swagger2markup convert -i PUBLIC.json -d ./outdir/Step-1 -c swagger2markup.properties

titletext=$(grep -o '"title"[[:space:]]*:[[:space:]]*"[^"]*"' PUBLIC.json | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
