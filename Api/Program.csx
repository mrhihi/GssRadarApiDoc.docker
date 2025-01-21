#r "nuget: Microsoft.AspNetCore.App, 6.0.0" // 使用 ASP.NET Core 6
#r "nuget: Microsoft.Extensions.Hosting, 6.0.0"

using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Http;

var builder = WebApplication.CreateBuilder();
var app = builder.Build();
app.Urls.Add("http://0.0.0.0:5051");

// 定義路由
app.MapGet("/", () => "Hello, Web API in CSX!");
app.MapPost("/gendoc", async (HttpRequest req) =>
{
    try
    {
        var BASE_DIR = Path.Combine(Directory.GetCurrentDirectory(), "GssRadarApiDoc");

        if (!req.HasFormContentType)
        {
            return Results.BadRequest("Content type must be 'multipart/form-data'");
        }

        var form = await req.ReadFormAsync();
        var file = form.Files["file"];

        if (file == null)
        {
            return Results.BadRequest("No file uploaded");
        }

        // 儲存檔案
        var savePath = Path.Combine(BASE_DIR, "PUBLIC.json");
        Directory.CreateDirectory(Path.GetDirectoryName(savePath)!); // 確保目錄存在

        await using var stream = new FileStream(savePath, FileMode.Create);
        await file.CopyToAsync(stream);
        var process = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = "/bin/bash",
                Arguments = "Run.sh",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
                WorkingDirectory = BASE_DIR
            }
        };

        process.Start();
        var output = await process.StandardOutput.ReadToEndAsync();
        var error = await process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();

        if (process.ExitCode != 0)
        {
            return Results.BadRequest(new { Error = error });
        }

        var responseFilePath = Path.Combine(BASE_DIR, "outdir/Step-2/API.tar.gz");
        if (!System.IO.File.Exists(responseFilePath))
        {
            return Results.NotFound("The file was not found.");
        }

        var fileBytes = await System.IO.File.ReadAllBytesAsync(responseFilePath);

        // 刪除 api.tar.gz
        System.IO.File.Delete(responseFilePath);
        System.IO.File.Delete(savePath);

        return Results.File(fileBytes, "application/gzip", "api.tar.gz");

    }
    catch(System.Exception ex)
    {
        return Results.BadRequest(new { Error = ex.Message });
    }
});

// 啟動伺服器
await app.RunAsync();