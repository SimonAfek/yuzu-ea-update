$releasePage = Invoke-WebRequest -Uri 'https://github.com/pineappleEA/pineapple-src/releases/latest' -Method Get

$releaseTag = $releasePage.BaseResponse.ResponseUri.AbsoluteUri.Split('/')[-1]

$releaseAssetsPage = Invoke-WebRequest -Uri "https://github.com/pineappleEA/pineapple-src/releases/expanded_assets/$releaseTag" -Method Get

$windowsZipLink = (($releaseAssetsPage.Links | Select -ExpandProperty href) -like '*Windows*')[0]

$filename = 'yuzu.zip'

Invoke-RestMethod -Uri "https://github.com/$windowsZipLink" -Method Get -Headers $headers -OutFile $filename

Remove-Item "$PWD\*" -Exclude @($filename, $MyInvocation.MyCommand.Name) -Recurse

Expand-Archive -Path $filename -DestinationPath $PWD -Force

Remove-Item 'yuzu-windows-msvc-early-access\*.tar.xz'

Move-Item -Path 'yuzu-windows-msvc-early-access\*' -Destination $PWD

Remove-Item "$PWD\*" -Include @($filename, 'yuzu-windows-msvc-early-access')
