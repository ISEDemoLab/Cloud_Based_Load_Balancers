# Cloud_Based_Load_Balancers/test

The test scripts used are very simple scripts using `radtest` which is part of the `freeradius-utils` package.  If you do not have it already, use 
```
sudo apt install freeradius-utils -y
```

to install it.  Then you can create your own test script.

## RADTest
```
radtest
Usage: radtest [OPTIONS] user passwd radius-server[:port] nas-port-number secret [ppphint] [nasname]
        -d RADIUS_DIR       Set radius directory
        -t <type>           Set authentication method
                            type can be pap, chap, mschap, or eap-md5
        -P protocol         Select udp (default) or tcp
        -x                  Enable debug output
        -4                  Use IPv4 for the NAS address (default)
        -6                  Use IPv6 for the NAS address
```


In this example, I will use a script named `test.sh`

```
#!/usr/bin/bash
for seq in $(seq 100)
do
    echo $seq
    radtest cmoreton ISEisC00L 192.168.100.6:1812 $seq ISEisC00L
done
```

Make `test.sh` executable with `chmod 755 test.sh`
Run the `test.sh` script with `sudo ./test.sh`

The commands in the script are:
|Command|Function|
|---|---|
|`#!/usr/bin/bash`|#!/usr/bin/bash is a shebang line used in script files to set bash, present in the '/bin' directory, as the default shell for executing commands present in the file. It defines an absolute path /usr/bin/bash to the Bash shell.|
|`for seq in $(seq 100)`|Create a for...in...do loop and set the variable $seq to 100 so that it runs 100 times|
|`do`|Execute the command|
|`echo $seq`|Echo the command as many times as defined in the variable `$seq`|
|`radtest...$seq`|The full command to be run, including the variable|
|`done`|Script end|

There are 3 NGINX and 3 Traefik scripts, each script will run against a different Virtual IP (vip) on the respective Load Balancer.

## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>