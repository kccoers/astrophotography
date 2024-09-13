$json = @{
    "albums" = @()
}

$albums = Get-ChildItem -Path ".\albums"

if ($albums.Length -ge 1) {

    foreach($album in $albums) {
        $album_info = Get-Content -Path "$($album.FullName)\albumInfo.json" | ConvertFrom-Json

        $photos = Get-ChildItem -Path $album.FullName

        foreach ($photo in $photos) {
            $photo_info = @{
                "photoUrl" = "$($album_info.albumUrl)/$($photo.Name)"
            }

            $album_info.photos += $photo_info

        }

        $json.albums += $album_info

    }

} else {
    # Write-Host "No Albums Found"

}

$json = $json | ConvertTo-Json -Depth 4

Set-Content -Path ".\data.json" -Value $json

