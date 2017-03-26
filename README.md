How much for this
=================

Simple API to extract prices for some e-commerce sites.

# Endpoints

## `GET /:shop_name/:id`

Retrieves the price for the [shop name](#available-shops) item specified ID.

# Available shops

- Amazon.fr [`amazonfr`]
  Fields: `name`, `price`, `image` (first on list)
- Amazon.de [`amazonde`]
  Fields: `name`, `price`, `image` (first on list)
- Amazon.it [`amazonit`]
  Fields: `name`, `price`, `image` (first on list)
- Amazon.nl [`amazonnl`]
  Fields: `name`, `price`, `image` (first on list)
- Amazon.es [`amazones`]
  Fields: `name`, `price`, `image` (first on list)
- Amazon.co.uk [`amazonuk`]
  Fields: `name`, `price`, `image` (first on list)

# Contributing

Install all the requirements using bundler:

```
bundler install
```

And then just run the main script:

```
ruby hmfw.rb
```

You can call the API at: `http://localhost:4567`.


## Example call

```
GET http://localhost:4567/amazones/B01N9RTMWS


```
