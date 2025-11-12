# Test

Ensure that the file `~root/.ssh/authorized_keys` exists and has an SSH public
key in it that can be used for login.

## Run the server

```
bash test/run_server.sh
```

This will be a oneshot server that will serve only 1 session and then exit.

## Run the client (noninteractive exec)

```
bash test/run_client.sh
```
