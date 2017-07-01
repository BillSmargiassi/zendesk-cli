# ZenDesk Command Line Tool

Request information from ZenDesk and output it in several forms like JSON, Markdown, or TaskPaper. Some of this is simply easier than using `curl`; some of it would require more post processing than I want to do.

I pipe the JSON output to [`jq`][1] often. I use the TaskPaper to send to OmniFocus, and I document tickets with a certain format that corresponds to a Ulysses filter.

## Configuration

Create a file named .zdapi.json in your home folder. Put the API URL, your agent email, and a valid API key in it like this:

```
{
	"url": "https://»site«.zendesk.com/api/v2",
	"username": "»agent email«",
	"token": "»API token«"
}
```

Copy over the file zdapi.json.template to /.zdapi.json to get started.

## Usage

There are 5 commands:

1. `search` — Return JSON results for a generic search, for tickets, users, using tags, etc. It doesn’t seem to work with “id:»id number«” though.
2. `user` — Return JSON describing a user
3. `org` — Return JSON describing an organization
4. `ticketproject` — Generate a TaskPaper format initial project for the ticket
5. `ticketnotes` — Generate the Markdown ticket notes headline I use

## Troubleshooting

### I get intermittent SSL errors

As far as I know, this just happens occasionally with ZenDesk’s API. Retry with the same arguments and it will probably work.

[1]:	https://stedolan.github.io/jq/ "jq JSON processor"
