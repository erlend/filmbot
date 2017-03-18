# FilmBot

Helping out with arranging movie night using Trello.

## Configuration

| Variable               | Description                                  |
| ---------------------- | -------------------------------------------- |
| TRELLO_CONSUMER_KEY    | Key from https://trello.com/app-key          |
| TRELLO_CONSUMER_SECRET | OAuth secret from https://trello.com/app-key |
| TRELLO_PENDING_LIST_ID | The id of the list containing pending movies |
| THEMOVIEDB_API_KEY     | API Key from https://themoviedb.org          |

## Database creation / updating

    bin/rake db:migrate
