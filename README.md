# RG Dashboard API

A Rails API to end points to fetch stock quotes and watch lists.

## Development

### Initialization
```shell
$ gem install bundler
$ bundle check || bundle install
```

### Start server
```shell
$ rails server
```
### Authentication

#### Get your user token
```shell
curl 'http://localhost:3000/authenticate' \
  -X POST \
  -H 'Content-Type: application/json' \
  -d '{"email":"<EMAIL>","password":"<PASSWORD>"}'
```

### Usages

#### Fetch a specific stock quote
- `<TICKER>` is the stock's ticket symbol (e.g. AAPL for Apple)
- `<TOKEN>` is the user's authentication token

```shell
curl 'http://localhost:3000/api/v1/quotes/<TICKER>' \
  -X GET \
  -H 'Authorization: <TOKEN>' \
  -H 'Content-Type: application/json'
```

Sample Response:
```shell
{
  "quote": {
    "ticker": "AAPL",
    "ticker_color": "#666666",
    "company_name": "Apple Inc",
    "open_price": 22.53,
    "delta": 0.228,
    "current_price": 27.67,
    "tags": [
      "lifestyle"
    ]
  }
}
```

#### Fetch all watch lists
- `<TOKEN>` is the user's authentication token

```shell
curl 'http://localhost:3000/api/v1/watchlists' \
  -X GET \
  -H 'Authorization: <TOKEN>' \
  -H 'Content-Type: application/json'
```

Sample Response:
```shell
{
  "watchlists": [
    {
      "uid": "a1b2c3",
      "name": "Buy the Dip!!!"
    },
    {
      "uid": "d4e5f6",
      "name": "Undervalued Stocks"
    }
  ]
}
```

#### Fetch a specific watch list and its stock quotes
- `<WATCHLIST-UID>` is the unique identifier for a watch list
- `<TOKEN>` is the user's authentication token

```shell
curl 'http://localhost:3000/api/v1/watchlists/<WATCHLIST-UID>' \
  -X GET \
  -H 'Authorization: <TOKEN>' \
  -H 'Content-Type: application/json'
```

Sample Response:
```shell
{
  "watchlist": {
    "uid": "a1b2c3",
    "name": "Buy the Dip!!!",
    "stocks": [
      {
        "ticker": "AMZN",
        "ticker_color": "#C26C03",
        "company_name": "Amazon.com, Inc.",
        "open_price": 61.91,
        "delta": 0.217,
        "current_price": 75.34,
        "tags": [
          "ecommerce"
        ]
      },
      {
        "ticker": "TSLA",
        "ticker_color": "#E31937",
        "company_name": "Tesla Inc",
        "open_price": 72.05,
        "delta": -0.264,
        "current_price": 53.03,
        "tags": [
          "auto",
          "tech"
        ]
      }
    ]
  }
}
```

### Run Test Suite
```shell
$ rspec spec
```
