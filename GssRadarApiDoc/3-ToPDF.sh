#!/bin/bash
if [ "$1" == "" ] || [ "$1" == "hcm" ]; then
    coverTpl="hcm"
else
    coverTpl=$1
fi

asciidoctor-pdf -a scripts=cjk -a pdf-theme=./themes/pdf.yml -a pdf-fontsdir=./themes outdir/Step-2/API-$coverTpl.adoc
