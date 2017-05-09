

$cmd = {
    $drive_letter = "S:"
    $share_display_root = "\\vchdsgeneralstorage.file.core.windows.net\vchdsfileshare"
    $ps_drive = Get-PSDrive -PSProvider "FileSystem" | Where-Object {$_.DisplayRoot -eq $share_display_root}
    Write-Host $ps_drive
    if ($ps_drive -eq $null) {
        Write-Host "MOUNTING $share_display_root to ${ps_drive}:"
        cmdkey /add:vchdsgeneralstorage.file.core.windows.net /user:AZURE\vchdsgeneralstorage /pass:ZYLpWwtoR9Pn7gftHom21gJXDjhFtnrJqQJsDLMBiv2fOsfefrg86En0T5PkC7RInsqsPDyXKr4l/N542nhYJQ==
        net use $drive_letter \\vchdsgeneralstorage.file.core.windows.net\vchdsfileshare
    }
    else 
    {
        Write-Host "$share_display_root is ALREADY mounted to ${ps_drive}:"
    }
}