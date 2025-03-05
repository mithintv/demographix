## Local Development

### Run

```sh
flask run
```

### Environment Variables

Enviornment variables should be supplied via a `secrets.sh` in `api` directory. `.envrc` uses `direnv` to load these variables upon entering the directory in a terminal.

## Database

### Seeding

Seeding can be done from the root directory `/demographix` with the following command. Note that the command requires arguments to be passed in but the calling it without any will show the help menu with the available arguments.

```sh
python -m api.scripts.seed
```
