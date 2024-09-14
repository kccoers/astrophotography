$json = @()

$albums = Get-ChildItem -Path ".\albums"

if ($albums.Length -ge 1) {

    $albums_counter = 0

    foreach($album in $albums) {
        $albums_counter += 1

        $album_info = Get-Content -Path "$($album.FullName)\albumInfo.json" | ConvertFrom-Json

        $album_info.id = $albums_counter

        $photos = Get-ChildItem -Path $album.FullName

        foreach ($photo in $photos) {
            $photo_info = @{
                "photoUrl" = "$($album_info.albumUrl)/$($photo.Name)"
            }

            $album_info.photos += $photo_info

        }

        $json += $album_info

    }

}

$json = $json | ConvertTo-Json -Depth 4

Set-Content -Path ".\data.json" -Value "[$($json)]"

