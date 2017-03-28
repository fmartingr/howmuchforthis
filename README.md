How much for this
=================

Simple API to extract prices for some e-commerce sites.

# Endpoints

## `GET /:shop_name/:id`

Retrieves the price for the [shop name](#available-shops) item specified ID.

# Available shops

- All amazon shops

# Contributing

Install all the requirements using bundler:

```
bundler install
```

And then just run the main script:

```
ruby hmfw/main.rb
```

You can call the API at: `http://localhost:4567`.


## Example call

```
GET http://localhost:4567/amazonuk/B01N9RTMWS

{
    "currency": "EUR",
    "image": "https://images-na.ssl-images-amazon.com/images/I/61Ly9jIq-cL._SL1000_.jpg",
    "name": "HORI Compact Playstand for Nintendo Switch Officially Licensed by Nintendo",
    "price": null
}
```
