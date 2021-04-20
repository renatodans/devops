Expand-Archive -Path .\App.zip -DestinationPath "temp"

$basePath = "$(System.DefaultWorkingDirectory)\_APP-CI\drop"
$filePath = $basePath + "\temp\log4net.config"
$content = [xml](Get-Content $filePath)
$content.log4net.appender.InstrumentationKey.value = "$(ApplicationInsights.InstrumentationKey)"
$content.Save($filePath);

Compress-Archive -Path .\temp\* -DestinationPath "App.zip" -Force

Write-Host "Update successfully"
