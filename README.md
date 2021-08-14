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
  "data": [
    {
      "id": "abc123",
      "type": "watchlist",
      "attributes": {
        "name": "Buy the Dip!!!",
        "stocks": [
          {
            "ticker": "AAPL",
            "ticker_color": "#666666",
            "company_name": "Apple Inc",
            "open_price": 30.07,
            "delta": 0.038,
            "current_price": 31.21,
            "tags": [
              "lifestyle"
            ]
          }
        ]
      }
    }
  ]
}
```

#### Fetch a specific watch list
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
  "data": {
    "id": "abc123",
    "type": "watchlist",
    "attributes": {
      "name": "Buy the Dip!!!",
      "stocks": [
        {
          "ticker": "AAPL",
          "ticker_color": "#666666",
          "company_name": "Apple Inc",
          "open_price": 70.96,
          "delta": -0.146,
          "current_price": 60.6,
          "tags": [
            "lifestyle"
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
}
```

#### Create a watch list
- `<TOKEN>` is the user's authentication token

```shell
curl 'http://localhost:3000/api/v1/watchlists/' \
  -X POST \
  -H 'Authorization: <TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Stonks Watchlist",
    "stocks": ["AMC","GME"]
  }'
```

Sample Response:
```shell
{
  "data": {
    "id": "86923fb8-f990-4075-8077-5c6e44c1ef8d",
    "type": "watchlist",
    "attributes": {
      "name": "Stonks Watchlist",
      "stocks": [
        "AMC",
        "GME"
      ]
    }
  }
}
```

#### Update a watch list
- `<WATCHLIST-UID>` is the unique identifier for a watch list
- `<TOKEN>` is the user's authentication token

```shell
curl 'http://localhost:3000/api/v1/watchlists/<WATCHLIST-UID>' \
  -X PATCH \
  -H 'Authorization: <TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "My Top Picks",
    "add_stocks": ["AMZN","ETSY"],
    "remove_stocks": ["BIGC"]
  }'
```

#### Delete a watch list
- `<WATCHLIST-UID>` is the unique identifier for a watch list
- `<TOKEN>` is the user's authentication token

```shell
curl 'http://localhost:3000/api/v1/watchlists/<WATCHLIST-UID>' \
  -X DELETE \
  -H 'Authorization: <TOKEN>' \
  -H 'Content-Type: application/json'
```

Sample Response:
```shell
{}
```

### Run Test Suite
```shell
$ rspec spec
```
