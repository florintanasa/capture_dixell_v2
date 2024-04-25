# Requesting monitoring parameters from Dixell XWEB300D

In [version 1](https://github.com/florintanasa/capture_dixell_v1) I used the capture packets technique. For this I'm using a sniffing program **tshark** and I capture the packages sent by
server to the client.  

In version 2 I used the **curl** command to send the request data to the server. For this also I'm using **tshark** to catch the POST data
to the server.
For this we need to catch the exact url address, cookie, content type and the data sent to the server with POST command by the client.  
 
Command used, in console terminal, to capture the package was next:  

```shell
tshark -V -i tun0 -Y "ip.addr==192.168.0.15 and http.request.line" -T fields -e http.request.full_uri -e http.cookie -e http.content_type -e http.file_data
```
and the result in my case was:  

```text
http://192.168.0.15/cgi-bin/runtime.cgi   user=Florin     application/x-www-form-urlencoded       NDVC=8&DEV_0=1|2|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|&DEV_1=1|3|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|&DEV_2=1|4|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|&DEV_3=1|5|2857|3857|4857|5857|6857|20857|29857|32857|23857|1|35857|36857|38857|&DEV_4=1|6|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|&DEV_5=1|7|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|&DEV_6=1|8|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|&DEV_7=1|9|2858|3858|4858|8858|9858|18858|19858|20858|21858|24858|25858|17858|1|29858|30858|\n
```  
Some examples how we can use the curl program exist to the address https://reqbin.com/req/c-sma2qrvp/curl-post-form-example  

With this information we construct the **curl** command to check if work: 

```shell
curl -X POST http://192.168.0.15/cgi-bin/runtime.cgi -H "Content-Type: application/x-www-form-urlencoded" -b "user=Florin" -d "NDVC=8&DEV_0=1|2|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|&DEV_1=1|3|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|&DEV_2=1|4|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|&DEV_3=1|5|2857|3857|4857|5857|6857|20857|29857|32857|23857|1|35857|36857|38857|&DEV_4=1|6|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|&DEV_5=1|7|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|&DEV_6=1|8|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|&DEV_7=1|9|2858|3858|4858|8858|9858|18858|19858|20858|21858|24858|25858|17858|1|29858|30858|"
```  
and the answer in my case was:  

```text
2|1|0|5.8|0|0|4.0|100.0|0|0|0|0|0|0|0|1|0|0|0000000000
3|1|0|5.5|0|0|4.0|100.0|0|0|0|0|0|0|0|1|0|0|0000000000
4|1|0|5.5|0|0|4.0|100.0|0|0|0|0|0|0|0|1|0|0|0000000000
5|0|0|13.2|15.0|0.0|13.2|-20.0|-20.0|0|0|0|0|0|0|0|00000000
6|1|0|-19.5|-22.1|0.0|-19.6|-20.0|-20.0|0|0|0|1|0|0|0|00000000000
7|0|0|12.5|14.1|0.0|12.5|-20.0|-20.0|0|0|0|0|0|0|0|00000000
8|1|0|7.0|5.7|0.0|7.0|6.0|6.0|1|0|0|1|0|0|0|00000000
9|0|0|12.7|0|0|4.0|100.0|0|0|0|0|0|0|0|0|0|0|0000000000
```
so it's work. We can construct a script to insert these parameters into tables from time series database TimescaleDB.  

![Screen capture with the script run and the data from tables](./img/script_run.png)  

The loop message it's for debug only, later I added a logging file for errors and maybe for other useful messages.  

## Install
Download the files:  
```shell
wget https://raw.githubusercontent.com/florintanasa/capture_dixell_v2/master/capture_dixell.sh
wget https://raw.githubusercontent.com/florintanasa/capture_dixell_v2/master/variable_command
wget https://raw.githubusercontent.com/florintanasa/capture_dixell_v2/master/capture-dixell.service
```
### Run locally
To run from current directory is necessary to modify the line from where is reading variable_command:  

```shell
while IFS="|" read -r RUN TIME IP < /usr/local/etc/variable_command; do
```
to  
```shell
while IFS="|" read -r RUN TIME IP < variable_command; do
```

### Run like service

After you downloading move files in their locations (work by root or with sudo command):
```shell
mv capture_dixell.sh /usr/local/bin/
mv variable_command /usr/local/etc/
mv capture-dixell.service /etc/systemd/system/
```
then reload systemd to know by capture-dixell.service:
```shell
systemctl daemon-reload
```
the start the service:
```shell
systemctl start capture-dixell.service
```
check if the service start and run ok:
```shell
systemctl status capture-dixell.service
```  
if everything is ok we see a message like:  
```shell
● capture-dixell.service - Run the script to request data from Dixell XWEB300D
     Loaded: loaded (/etc/systemd/system/capture-dixell.service; disabled; vendor preset: enabled)
     Active: active (running) since Thu 2024-04-25 14:13:55 EEST; 31min ago
   Main PID: 54429 (capture_dixell.)
      Tasks: 2 (limit: 18772)
     Memory: 1.2M
        CPU: 1min 5.518s
     CGroup: /system.slice/capture-dixell.service
             ├─54429 /bin/bash /usr/local/bin/capture_dixell.sh
             └─65319 sleep 10

apr 25 14:44:38 florin-laptop capture_dixell.sh[65233]: Inserted into cc8
apr 25 14:44:38 florin-laptop capture_dixell.sh[65233]: Inserted into cr9
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cr2
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cr3
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cr4
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cc5
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cc6
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cc7
apr 25 14:44:49 florin-laptop capture_dixell.sh[65296]: Inserted into cc8
apr 25 14:44:50 florin-laptop capture_dixell.sh[65296]: Inserted into cr9

```
If exist problems with network after the service was started we found the message:  
```shell
● capture-dixell.service - Run the script to request data from Dixell XWEB300D
     Loaded: loaded (/etc/systemd/system/capture-dixell.service; disabled; vendor preset: enabled)
     Active: active (exited) since Thu 2024-04-25 14:13:55 EEST; 1h 18min ago
    Process: 54429 ExecStart=/usr/local/bin/capture_dixell.sh (code=exited, status=0/SUCCESS)
   Main PID: 54429 (code=exited, status=0/SUCCESS)
        CPU: 2min 32.979s

apr 25 15:27:07 florin-laptop capture_dixell.sh[79959]: Inserted into cr9
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cr2
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cr3
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cr4
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cc5
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cc6
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cc7
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cc8
apr 25 15:27:18 florin-laptop capture_dixell.sh[80020]: Inserted into cr9
apr 25 15:27:29 florin-laptop capture_dixell.sh[54429]: Check where is the problems for route at Dixell XWEB300D - IP 192.168.0.15
```
and is necessary to check the route and if IP is up, and then we restart the service:  
```shell
systemctl restart capture-dixell.service
```
