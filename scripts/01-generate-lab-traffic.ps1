<#
Lab 2 - Wireshark traffic generators.

Run each exercise's command separately when instructed,
while Wireshark is capturing on your active adapter.
#>

# Exercise A - DNS lookup
nslookup -type=A google.com. 192.168.1.1

# Exercise B - TCP three-way handshake over plain HTTP
curl.exe -4 -v --connect-timeout 10 --max-time 20 http://example.com/

# Exercise C - HTTP POST containing deliberately fake credentials
curl.exe -4 -v --connect-timeout 10 --max-time 20 -d "uname=wireshark-demo&pass=not-a-real-password" http://httpbin.org/status/204

# Exercise D - HTTP conversation for Follow TCP Stream
curl.exe -4 -v --connect-timeout 10 --max-time 20 http://example.com/