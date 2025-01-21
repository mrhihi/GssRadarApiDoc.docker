#!/usr/bin/env dotnet-script
#nullable enable

using System;
using System.IO;
using System.Text;

const string NEWLINE = "\r\n";
void Main()
{
    string text = File.ReadAllText(@$"outdir/Step-2/{Args[0]}", Encoding.UTF8);

    // 調整欄寬(API 範例中的回傳格式)
    text = text.Replace("[options=\"header\", cols=\".^2a,.^14a,.^4a\"]", "[options=\"header\", cols=\".^2a,.^4a,.^14a\"]");
    // 調整欄寬(資料結構)
    text = text.Replace("[options=\"header\", cols=\".^3a,.^11a,.^4a\"]", "[options=\"header\", cols=\".^5a,.^8a,.^4a\"]");

    // 資料結構換頁
    text = ModelsChangeLine(text);

    // 去掉回傳型態裡是 Array 的內容
    text = text.Replace("|**200**|OK|< <<", "|**200**|OK|<<");
    text = text.Replace(">> > array", ">>");

    text = ChangeResult(text);
    text = RemoveSpecificItem(text);

    File.WriteAllText(@$"outdir/Step-2/{Args[0]}", text.TrimEnd(new char[]{'\r', '\n', '<'}));
}

string RemoveSpecificItem(string text)
{
    const string ITEM1 = "__必輸__";
    const string ITEM2 = "__可選__";
    return text.Replace(ITEM1, "").Replace(ITEM2, "");
}

string ModelsChangeLine(string text)
{
    const string SEPARATOR1 = "[[_definitions]]";
    const string SEPARATOR2 = "[[_gss_radar_datahub_domain_models";
    StringBuilder result = new StringBuilder();
    string[] r1 = text.Split(SEPARATOR1);
    result.Append(r1[0]).Append(NEWLINE).Append(SEPARATOR1).Append(NEWLINE);

    string[] r2 = r1[1].Split(SEPARATOR2);
    string r3 = r2[0];
    result.Append($"{r3}{SEPARATOR2}");
    result.Append(string.Join($"<<<{NEWLINE}{SEPARATOR2}", r2.Skip(1).ToArray())).Append(NEWLINE);

    return result.ToString();
}

string ChangeResult(string text)
{
    string[] lines = text.Split(NEWLINE);
    bool rfound = false;
    bool rpush = false;
    StringBuilder sb = new StringBuilder();
    StringBuilder sbr = new StringBuilder();
    foreach(string l in lines)
    {
        if (l == "===== Response 200") rfound = true;
        if (rpush) {
            if (l == "----") {
                rpush = false;
                rfound = false;
                sb.Append(@"{").Append(NEWLINE);
                sb.Append(@"  ""HttpStatusCode"": 200,").Append(NEWLINE);
                sb.Append(@"  ""ErrorCode"": """",").Append(NEWLINE);
                sb.Append(@$"  ""Result"": {sbr.ToString().TrimEnd(NEWLINE.ToCharArray())},").Append(NEWLINE);
                sb.Append(@"  ""ExtraData"": {}").Append(NEWLINE);
                sb.Append(@"}").Append(NEWLINE);
                sb.Append(l);
                sb.Append(NEWLINE);
                sbr.Clear();
            } else {
                sbr.Append("  ");
                sbr.Append(l);
                sbr.Append(NEWLINE);
            }
        } else {
            sb.Append(l);
            sb.Append(NEWLINE);
        }
        if (rfound && l == "----") rpush = true;
    }

    return sb.ToString();
}

Main();