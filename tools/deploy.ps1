param([switch]$Watch)
$ErrorActionPreference = 'Stop'
$project = Split-Path $PSScriptRoot -Parent
Set-Location $project
$tomcat = Join-Path $project '.runtime/apache-tomcat-9.0.123'
$mavenCommand = Get-Command mvn.cmd -ErrorAction SilentlyContinue
$maven = if ($mavenCommand) { $mavenCommand.Source } else {
    Get-ChildItem 'C:/Program Files/JetBrains' -Filter mvn.cmd -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}
if (!$maven) { throw 'Khong tim thay Maven. Cai Maven va them bin vao PATH.' }
if (!(Test-Path "$tomcat/bin/catalina.bat")) { throw "Khong tim thay Tomcat: $tomcat" }
$jdk = Get-ChildItem 'C:/Program Files/Java' -Directory -Filter 'jdk-*' |
    Where-Object { Test-Path "$($_.FullName)/bin/javac.exe" } |
    Sort-Object Name | Select-Object -First 1
if ($jdk) { $env:JAVA_HOME = $jdk.FullName }
$env:CATALINA_HOME = $tomcat
$env:CATALINA_BASE = $tomcat
function Deploy {
    Write-Host 'Building ShopMan32...'
    $buildDir = [IO.Path]::GetFullPath((Join-Path $project 'target'))
    if ($buildDir -ne "$project\target") { throw 'Unexpected build directory' }
    if (Test-Path -LiteralPath $buildDir) { Remove-Item -LiteralPath $buildDir -Recurse -Force }
    & $maven -B -o -s "$project/.runtime/maven-settings.xml" package
    if ($LASTEXITCODE -ne 0) { throw 'Build failed; deployment was not changed.' }
    $war = Join-Path $project 'target/ShopMan32.war'
    Copy-Item -LiteralPath $war -Destination "$tomcat/webapps/ShopMan32.war" -Force
    $listener = Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
    if (!$listener) {
        Start-Process -FilePath "$env:JAVA_HOME/bin/java.exe" -WindowStyle Hidden -WorkingDirectory $tomcat -ArgumentList @(
            "-Dcatalina.home=`"$tomcat`"", "-Dcatalina.base=`"$tomcat`"",
            '-classpath', "`"$tomcat/bin/bootstrap.jar;$tomcat/bin/tomcat-juli.jar`"",
            'org.apache.catalina.startup.Bootstrap', 'start'
        ) -RedirectStandardOutput "$project/.runtime/tomcat-stdout.log" -RedirectStandardError "$project/.runtime/tomcat-stderr.log"
    }
    Write-Host 'Deployed: http://localhost:8080/ShopMan32/'
}
function Source-Stamp {
    $files = @(Get-ChildItem "$project/src/main" -Recurse -File) + @(Get-Item "$project/pom.xml")
    return ($files | Sort-Object FullName | ForEach-Object {
        "$($_.FullName)|$($_.LastWriteTimeUtc.Ticks)|$($_.Length)"
    }) -join "`n"
}
$stamp = Source-Stamp
Deploy
if ($Watch) {
    Write-Host 'Watching src/main and pom.xml. Press Ctrl+C to stop.'
    while ($true) {
        Start-Sleep -Seconds 2
        $next = Source-Stamp
        if ($next -ne $stamp) {
            Start-Sleep -Seconds 1
            $stamp = Source-Stamp
            try { Deploy } catch { Write-Warning $_.Exception.Message }
        }
    }
}
