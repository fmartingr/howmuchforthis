# coding: utf-8

require_relative 'base'

class AmazonBaseShop < Shop
  BASE_URL = 'https://amazon.com/dp/%s'.freeze
  FIELD_XPATH = {
    name: "//span[@id='productTitle']//text()",
    price: [
      # Main content price
      "//span[@id='priceblock_ourprice']//text()",
      # Right block price (when multiple product varians)
      "//div[@id='buyNewSection']//span[contains(@class,'offer-price')]//text()"
    ],
    image: "//div[@id='imgTagWrapperId']/img/@data-old-hires"
  }.freeze
  CURRENCY = {
    code: 'EUR',
    symbol: '€'
  }.freeze

  def initialize
    super
    @currency = self.class::CURRENCY
  end

  def parse_name(name)
    name.to_s.strip
  end

  def parse_price(price)
    unless price.empty?
      price.to_s
           .sub(',', '.')
           .sub(@currency[:symbol], '')
           .sub(@currency[:code], '')
           .strip
           .to_f
    end
    nil
  end

  def parse_item(item)
    item.merge! currency: @currency[:code]
  end
end

class AmazonAU < AmazonBaseShop
  # Australia
  BASE_URL = 'https://amazon.au/dp/%s'.freeze
  CURRENCY = {
    code: 'AUD',
    symbol: '$'
  }.freeze
end

class AmazonBR < AmazonBaseShop
  # Brazil
  BASE_URL = 'https://amazon.com.br/db/%s'.freeze
  CURRENCY = {
    code: 'R',
    symbol: 'R$'
  }.freeze
end

class AmazonCA < AmazonBaseShop
  # Canada
  BASE_URL = 'https://amazon.com/dp/%s'.freeze
  CURRENCY = {
    code: 'CDN',
    symbol: 'CDN$'
  }.freeze
end

class AmazonCN < AmazonBaseShop
  # Canada
  BASE_URL = 'https://amazon.cn/dp/%s'.freeze
  CURRENCY = {
    code: 'CNY',
    symbol: '￥'
  }.freeze
end

class AmazonDE < AmazonBaseShop
  # Germany
  BASE_URL = 'https://amazon.de/dp/%s'.freeze
end

class AmazonES < AmazonBaseShop
  # Spain
  BASE_URL = 'https://amazon.es/dp/%s'.freeze
end

class AmazonFR < AmazonBaseShop
  # France
  BASE_URL = 'https://amazon.fr/dp/%s'.freeze
end

class AmazonIN < AmazonBaseShop
  # India
  BASE_URL = 'https://amazon.in/dp/%s'.freeze
  CURRENCY = {
    code: 'INR',
    symbol: '₹'
  }.freeze
end

class AmazonIT < AmazonBaseShop
  # Italy
  BASE_URL = 'https://amazon.it/dp/%s'.freeze
end

class AmazonJP < AmazonBaseShop
  # Japan
  BASE_URL = 'https://amazon.co.jp/dp/%s'.freeze
  CURRENCY = {
    code: 'JPY',
    symbol: '￥'
  }.freeze
end

class AmazonMX < AmazonBaseShop
  # Mexico
  BASE_URL = 'https://amazon.mx/dp/%s'.freeze
  CURRENCY = {
    code: 'MXN',
    symbol: '$'
  }.freeze
end

class AmazonNL < AmazonBaseShop
  # Netherlands
  BASE_URL = 'https://amazon.nl/dp/%s'.freeze
end

class AmazonUK < AmazonBaseShop
  # United Kingdom
  BASE_URL = 'https://amazon.co.uk/dp/%s'.freeze
  CURRENCY = {
    code: 'GBP',
    symbol: '£'
  }.freeze
end

class AmazonUS < AmazonBaseShop
  # United States
  BASE_URL = 'https://amazon.com/dp/%s'.freeze
  CURRENCY = {
    code: 'USD',
    symbol: '$'
  }.freeze
end
