require 'open-uri'

require 'nokogiri'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if settings.development?


class Shop
  @@base_url = nil
  @@http_headers = {
    'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36'
  }

  def download_url_contents(url)
    open(url, @@http_headers) do |handler|
      return handler.read
    end
  end

  def retrieve_price_from_contents(contents)
    raise NotImplementedError
  end

  def parse_price(price)
    raise NotImplementedError
  end

  def get_price_from_id(id)
    contents = download_url_contents(@@base_url % [id])
    price = retrieve_price_from_contents contents
    parse_price price.to_s
  end
end

class AmazonSpain < Shop
  @@base_url = "https://amazon.es/dp/%s"

  @@xpath = {
    'main_content' => "//span[@id='priceblock_ourprice']//text()",
    'buynew_block' => "//div[@id='buyNewSection']//span[contains(@class, 'offer-price')]//text()"
  }

  # Price DOM elements:
  # - Main element: #block_outprice
  # - When multiple product variants: #buyNewSection .offer-price
  # Result string: EUR XX,XX

  def retrieve_price_from_contents(contents)
    @doc = Nokogiri::HTML contents
    price = retrieve_price_from_main_content
    return price if not price.empty?

    price = retrieve_price_from_buynew_block
    return price if not price.empty?

    nil
  end

  def parse_price(price)
    if not price.empty?
      price.sub!(',', '.').sub!('EUR', '').to_f
    end
  end

  def retrieve_price_from_main_content
    @doc.xpath(@@xpath['main_content'])
  end

  def retrieve_price_from_buynew_block
    @doc.xpath(@@xpath['buynew_block'])
  end
end

shops = {
  :amazones => AmazonSpain
}


get '/:shop_name/:id' do |shop_name, id|
  if shops.key?(shop_name.to_sym) then
    shop = shops[shop_name.to_sym].new
    price = shop.get_price_from_id(id)
    json :price => price
  else
    status 404
  end
end
