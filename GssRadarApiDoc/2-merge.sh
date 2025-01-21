#!/bin/bash
if [ "$1" == "" ] || [ "$1" == "hcm" ]; then
    coverTpl="hcm"
    title="Vital HCM API"
else
    coverTpl=$1
    title="RADAR API"
fi

asciidoctor-pdf -a scripts=cjk -a pdf-theme=./themes/pdf.yml -a pdf-fontsdir=./themes themes/0-cover-$coverTpl.adoc

rm -f "outdir/Step-2/0-cover-$coverTpl.pdf"
mkdir -p "outdir/Step-2"
mv "themes/0-cover-$coverTpl.pdf" "outdir/Step-2/"

# cat themes/0-cover-$coverTpl.adoc > outdir/Step-2/API-$coverTpl.adoc

echo "= $title" > outdir/Step-2/API-$coverTpl.adoc
echo ":front-cover-image: image::../../../../outdir/Step-2/0-cover-$coverTpl.pdf" >> outdir/Step-2/API-$coverTpl.adoc
echo ":toc-title: 索引" >> outdir/Step-2/API-$coverTpl.adoc
echo ":toc:" >> outdir/Step-2/API-$coverTpl.adoc
echo "&nbsp;" >> outdir/Step-2/API-$coverTpl.adoc
echo "<<<" >> outdir/Step-2/API-$coverTpl.adoc
echo "<<<" >> outdir/Step-2/API-$coverTpl.adoc

cat themes/0.1-authentication.adoc >> outdir/Step-2/API-$coverTpl.adoc
echo "<<<" >> outdir/Step-2/API-$coverTpl.adoc


echo "[[_apis]]" >> outdir/Step-2/API-$coverTpl.adoc
echo "== API 列表" >> outdir/Step-2/API-$coverTpl.adoc
echo "" >> outdir/Step-2/API-$coverTpl.adoc
# cat outdir/Step-1/1-paths.adoc >> outdir/Step-2/API-$coverTpl.adoc
# echo "<<<" >> outdir/Step-2/API-$coverTpl.adoc

for i in $(ls outdir/Step-1/operations/*.adoc);
do 
    cat $i >> outdir/Step-2/API-$coverTpl.adoc;
    echo "<<<" >> outdir/Step-2/API-$coverTpl.adoc;
done

cat outdir/Step-1/2-definitions.adoc >> outdir/Step-2/API-$coverTpl.adoc
echo "<<<" >> outdir/Step-2/API-$coverTpl.adoc

./2.1-replace.csx "API-$coverTpl.adoc"

