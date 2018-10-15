# migrator-helper

A helper for [GitHub.com migration](https://help.github.com/enterprise/admin/guides/migrations/about-migrations/). Use gmake 4.x or above. If you're on macOS, just run `brew install make`

- Run `make migration.json` to start the migration
- Run `make state` to check the migration state
- If the state is `exported`, run `make archive` to get the archive link
- Run `make clean` to cleanup
