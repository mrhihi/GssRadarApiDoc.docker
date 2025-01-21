# Radar API 文件產生器

## docker image 製作說明

- 檔案及目錄說明
  - GssRadarApiDoc 製作文件相關工具安裝目錄(包含格式、中文化及相關處理腳本)
    - 運作方式
      - 透過 swagger2markup-cli 把 Swagger JSON 轉成 adoc
      - 透過 csx 腳本，整理相關 adoc 內容
      - 透過 asciidoctor-pdf 把 adoc 轉成 pdf
  - Api 簡易的 WepApi 接收外部產生文件的要求，執行 GssRadarApiDoc 中的工具產生文件，並回傳結果
  - libexec 把 Swagger JSON 轉成 adoc 的工具(swagger2markup-cli)
    - swagger2markup-cli-1.3.3.jar 客製後支援中文語系的 Swagger 轉換工具
    - swagger2markup-cli-1.3.3-x.jar 原始 Swagger 轉換工具

- 建置 docker image 指令

```bash
# 一般 x86_64 的環境 
docker build -t gssradarapidoc:1.0-x64 .

# arm 的環境(macOS M 系列 CPU 可以用這個在本機測試)
docker build -t gssradarapidoc:1.0-arm .
```

## docker image 佈署說明

- 建置好的 image 可以透過以下方式，把 image 發佈到別台機器上(注意 CPU 架構要一致)

```bash
# 將 docker image 另存成檔案(儲存的檔案格式為 tar)
docker save -o <檔案名稱>.tar <image-name>:<tag>
```

- 在另一台機器上，透過以下方式，將 image 載入

```bash
docker load -i /path/to/destination/my-image.tar

# 確認 image 是否載入成功
docker images
```

## docker container 執行說明

- 載入 image 後，可以透過以下方式，啟動 container

```bash
# 一般 x86_64 的環境
docker container run -d -p 5051:5051 gssradarapidoc:1.0-x64 dotnet-script /app/Api/Program.csx

# arm 的環境(macOS M 系列 CPU 可以用這個在本機測試)
docker container run -d -p 5051:5051 gssradarapidoc:1.0-arm dotnet-script /app/Api/Program.csx
```

以上是在背景執行的方式，如果需要互動偵錯，可以把 `-d` 移除，改成 `-it`，如下

```bash
# 執行 container 並進入 console 模式
docker container run -it -p 5051:5051 gssradarapidoc:1.0-x64

# 手動執行 API 服務，需在 container 內執行以下指令
dotnet-script /app/Api/Program.csx
```

Container 內含 vim 可以透過 vi 進行文字編輯。

## 其他 docker 指令說明

```bash
# 在 Container 外部，透過 docker cp 複製檔案到 Container 內部
docker cp ./libexec/pegdown-1.6.0.jar d37e7a820c38:/app/libexec
docker cp ./libexec/parboiled-java-1.1.7.jar d37e7a820c38:/app/libexec

# 在 Container 外部，透過 docker cp 複製檔案到 Container 內部
docker cp d37e7a820c38:/app/Api/Api.adoc ./Api.adoc

```
