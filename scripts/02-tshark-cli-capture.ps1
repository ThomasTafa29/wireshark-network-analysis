<#
Lab 2 - Command-line capture with TShark.

During Step 5, run one line at a time, from top to bottom.
Save the raw capture outside the repository.
#>

$tshark = "C:\Program Files\Wireshark\tshark.exe"

# 1. List the available capture interfaces.
& $tshark -D

# 2. Replace 5 with YOUR active interface number during Step 5.
$iface = 2
# 3. Capture 200 packets into the Windows temporary folder.
# Ctrl+C can stop the capture early.
& $tshark -i $iface -c 200 -w "$env:TEMP\cli-capture.pcapng"

# 4. Read back the first 10 packets.
& $tshark -r "$env:TEMP\cli-capture.pcapng" -c 10 -T fields -E header=y -e frame.number -e _ws.col.Protocol -e frame.len
# 5. After taking the supporting screenshot, delete the raw capture.
Remove-Item "$env:TEMP\cli-capture.pcapng"