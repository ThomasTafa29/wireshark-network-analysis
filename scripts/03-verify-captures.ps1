<#
Lab 2 - Capture evidence review.

Run this after completing and exporting all four exercises.
Review the output manually before publishing any captures.
#>

$tshark = "C:\Program Files\Wireshark\tshark.exe"
$dir = Join-Path $PSScriptRoot "..\captures"

function Show-Header($text) {
    Write-Host "`n=== $text ===" -ForegroundColor Cyan
}

# Confirm that all four expected files exist.
$expectedFiles = @(
    "01-dns-lookup.pcapng"
    "02-tcp-handshake.pcapng"
    "03-http-cleartext-credentials.pcapng"
    "04-tcp-stream-follow.pcapng"
)

foreach ($name in $expectedFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $dir $name))) {
        throw "Missing capture: $name. Finish the exercises first."
    }
}

# Review addresses and selected hostnames in every capture.
Get-ChildItem -Path $dir -Filter *.pcapng -File | ForEach-Object {
    Show-Header "$($_.Name) - address and hostname review"

    $count = (& $tshark -n -r $_.FullName -T fields -e frame.number |
        Measure-Object).Count

    Write-Host "Packets: $count"

    & $tshark -n -r $_.FullName -T fields `
        -e ip.src -e ip.dst -e ipv6.src -e ipv6.dst `
        -e dns.qry.name -e http.host |
        ForEach-Object { $_ -split "[\s,]+" } |
        Where-Object { $_ } |
        Sort-Object -Unique
}

Show-Header "DNS - ID, response flag, queried name, IPv4 answer"
& $tshark -n -r (Join-Path $dir "01-dns-lookup.pcapng") `
    -T fields -e dns.id -e dns.flags.response -e dns.qry.name -e dns.a

Show-Header "TCP handshake - first three packets"
& $tshark -n -r (Join-Path $dir "02-tcp-handshake.pcapng") -c 3

Show-Header "HTTP form - method, field names, fake values"
& $tshark -n -r (Join-Path $dir "03-http-cleartext-credentials.pcapng") `
    -Y "urlencoded-form" -T fields `
    -e http.request.method -e urlencoded-form.key -e urlencoded-form.value

Show-Header "Reconstructed TCP conversation - stream 0"
& $tshark -n -r (Join-Path $dir "04-tcp-stream-follow.pcapng") `
    -q -z "follow,tcp,ascii,0"