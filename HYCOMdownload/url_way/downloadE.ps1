# URL 列表文件
$urlList = "URLHYCOM_E_Missing1.txt"

$downloadDir = "G:\HYCOM\url\File\2012\E"

# 检查文件是否存在
if (-Not (Test-Path $urlList)) {Write-Host ($urlList + "Not Exist")}
# 检查下载目录是否存在，不存在则创建
if (-Not (Test-Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir
}

# 读取 URL 列表
$urls = Get-Content -Path $urlList

# 并行作业限制数量
$maxConcurrentJobs = 5
# 函数：获取当前运行中的作业数
function Get-RunningJobCount {
    return (Get-Job -State Running).Count
}

# 逐行读取 URL 并并行下载
foreach ($url in $urls) {
    # 等待直到当前运行中的作业数少于最大并行作业数
    while ((Get-RunningJobCount) -ge $maxConcurrentJobs) {
        Start-Sleep -Seconds 1
    }

    # 创建 Uri 对象
    $uri = [System.Uri]::new($url)
    # 手动解析文件名
    $filename = $url.Split('?')[1] + ".nc"

    # 如果URL中没有明确的文件名, 生成一个唯一的文件名
    if (-Not $filename) {
        $filename = [System.Guid]::NewGuid().ToString() + ".nc"
    }

    # 提取文件名
    $filePath = Join-Path -Path $downloadDir -ChildPath $filename

    # 使用 Start-Job 并行下载文件
    #Start-Job -ScriptBlock {
    #    param ($url, $filePath)
        Write-Host "Downloading $url to $filename ..."
        & curl -o $filename $url
        Write-Host "Finish: $filePath"
    #} -ArgumentList $url, $filename
}

# 等待所有下载任务完成
Get-Job | Wait-Job

# 打印下载完成的任务
Get-Job | ForEach-Object {
    Write-Host "Finish Downloading: $($_.Id)"
    Remove-Job -Id $_.Id
}