# Connecting Perl to External Binaries

Here is a sample repo to demonstrate how to use a simple Go program that reads from standard input a domain name in unicode form, and outputs the IDN ASCII version of the name.

The source code can be found in the `goidn` directory.

There is also a `lib` directory that contains a `GoIDN` library in Perl5 that uses `IPC::Open2` to spawn the program passed as a binary and attaches two (2) filehandles, one for reading, one for writing.

A method called `to_ascii(domain_name)` writes to the **write** filehandle, effectively passing the request to the Go program which returns instantly and through the **read** filehandle.

## How fast is this

A simple benchmark returns:

```
timethis 1000000: 11 wallclock secs ( 4.24 usr +  2.86 sys =  7.10 CPU) @ 140845.07/s (n=1000000)
```

So about ~14.1k calls a second on my Macbook Pro

