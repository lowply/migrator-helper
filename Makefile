#
# Use gmake 4.x or above
# If you're on macOS, just run `brew install make`
#

#
# Run `make migration.json` to start the migration
# Run `make state` to check the migration state
# If the state is `exported`, run `make archive` to get the archive link
# Run `make clean` to cleanup
#

ifndef ORG
$(error ORG is not set)
endif

ifndef REPO
$(error REPO is not set)
endif

ifndef GITHUB_TOKEN_COM
$(error GITHUB_TOKEN_COM is not set)
endif

HOST_COM := https://api.github.com
HEADER := \
	-H "Authorization: token ${GITHUB_TOKEN_COM}" \
	-H "Accept: application/vnd.github.wyandotte-preview+json"

migration.json:
	curl -s ${HEADER} \
		-X POST \
		-d '{"exclude_attachments":false,"repositories":["${ORG}/${REPO}"]}' \
		${HOST_COM}/orgs/${ORG}/migrations | jq . > migration.json

migration_id: migration.json
	cat migration.json | jq -r .id > migration_id

.PHONY: state
state: migration_id
	curl -s ${HEADER} \
		${HOST_COM}/orgs/${ORG}/migrations/$(file < migration_id) | jq -r .state

.PHONY: list
list:
	curl -s ${HEADER} \
		${HOST_COM}/orgs/${ORG}/migrations

.PHONY: delete
delete:
	curl -s ${HEADER} \
		-X DELETE \
		${HOST_COM}/orgs/${ORG}/migrations/$(file < migration_id)

.PHONY: get
get:
	curl -s ${HEADER} \
		${HOST_COM}/orgs/${ORG}/migrations/$(file < migration_id)

.PHONY: archive
archive:
	curl -s ${HEADER} \
		${HOST_COM}/orgs/${ORG}/migrations/$(file < migration_id)/archive

.PHONY: clean
clean:
	rm migration.json migration_id
