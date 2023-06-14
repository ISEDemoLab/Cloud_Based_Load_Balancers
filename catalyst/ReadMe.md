# Cloud_Based_Load_Balancers/catalyst

This is a command that has been porterd into IOS-XE from IOS and is available in virtually every version of IOS-XE.

You can use a built in command on Catalyst switches to load balance RADIUS requests.  By adding 
```
load-balance method least-outstanding
```

to your aaa server group, you are configuring load balancing to the PSNs in your server group to the server with the least number of outstanding sessions with a default group of 25 (25 cached authentications/authorizations) 

The full command is 
```
load-balance method least-outstanding [batch-size number] [ignore-preferred-server]
```

where you can assign the batch number and remove the preferred server.  In this case, the preferred-server adds session persistence, so do not `ignore-preferred-server`!

For more information read the [RADIUS Server Load Balancing chapter of the Security Configuration Guide, Cisco IOS XE Dublin 17.11.x](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst9600/software/release/17-11/configuration_guide/sec/b_1711_sec_9600_cg/radius_server_load_balancing.html)


## License

MIT

## Author

Charlie Moreton, <https://github.com/ISEDemoLab>