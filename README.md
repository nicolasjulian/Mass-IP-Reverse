# Mass-IP-Reverse
Reversing list of ip address to get bigger scope

```
$ git clone https://github.com/nicolasjulian/Mass-IP-Reverse.git
$ cd Mass-IP-Reverse
$ chmod +x Reverse-MultiThread.sh
$ Usage: ./myscript.sh COMMANDS: [-i <list.txt>] [-r <folder/>] [-l {1-1000}] [-t {1-10}] [-d {y|n}]

Command:
-i (domains.txt)     File input that contain ip to reverse
-r (result/)         Folder to store the all result 
-l (60|90|110)       How many list you want to send per delayTime
-t (3|5|8)           Sleep for -t when request is reach -l fold
-d (y|n)             Delete the list from input file per request
-h (To see this help guid)
"
```

# OR
You can use interactive mode 
```
$ ./Reverse-MultiThread.sh
```

Make sure you already installed CURL
```
apt install curl 
```
