$json = @()

$albums = Get-ChildItem -Path ".\albums"

if ($albums.Length -ge 1) {

    $albums_counter = 0

    foreach($album in $albums) {
        $albums_counter += 1

        $album_info = Get-Content -Path "$($album.FullName)\albumInfo.json" | ConvertFrom-Json

        $album_info.id = $albums_counter

        $photos = Get-ChildItem -Path $album.FullName

        $photos_counter = 0
        
        foreach ($photo in $photos) {
            if ($photo.Name.EndsWith("albumInfo.json")) { continue }

            $photo_wia_info = New-Object -ComObject Wia.ImageFile

            $photo_wia_info.loadFile("$($album.FullName)/$($photo.Name)")

            if     ($photo_wia_info.width -gt $photo_wia_info.height) { $photo_orientation = "landscape" }
            elseif ($photo_wia_info.width -eq $photo_wia_info.height) { $photo_orientation = "square" }
            else { $photo_orientation = "portrait" }

            $photo_info = [Ordered]@{
                "id" = $photos_counter += 1
                "orientation" = $photo_orientation
                "photoUrl" = "$($album_info.albumUrl)/$($photo.Name)"
            }

            $album_info.photos += $photo_info

        }

        $album_cover = $album_info.photos | Where-Object { $_.orientation -eq "landscape" } | Get-Random
        $album_info.albumCover = $album_cover.photoUrl

        $json += $album_info

    }

}


$json = $json | ConvertTo-Json -Depth 4

Set-Content -Path ".\data.json" -Value "[$($json)]"

