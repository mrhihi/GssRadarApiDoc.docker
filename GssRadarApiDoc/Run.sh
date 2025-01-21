#!/bin/bash

rm -rf "outdir/Step-1"
rm -rf "outdir/Step-2"

./1-Convert.sh

./2-merge.sh hcm
./3-ToPDF.sh hcm

./2-merge.sh radar
./3-ToPDF.sh radar

# 清除暫存檔
rm -f "outdir/Step-2/API-hcm.adoc"
rm -f "outdir/Step-2/API-radar.adoc"
rm -f "outdir/Step-2/0-cover-hcm.pdf"
rm -f "outdir/Step-2/0-cover-radar.pdf"

# 把產出的 API-hcm.pdf 跟 API-radar.pdf  tar 壓縮成一個檔案
tar -czf "outdir/Step-2/API.tar.gz" "outdir/Step-2/API-hcm.pdf" "outdir/Step-2/API-radar.pdf"

# 移除 pdf
rm -f "outdir/Step-2/API-hcm.pdf"
rm -f "outdir/Step-2/API-radar.pdf"

