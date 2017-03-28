# coding: utf-8
require_relative 'base'

class AmazonBaseShop < Shop
  BASE_URL = 'https://amazon.com/dp/%s'
  FIELD_XPATH = {
    :name => "//span[@id='productTitle']//text()",
    :price => [
      # Main content price
      "//span[@id='priceblock_ourprice']//text()",
      # Right block price (when multiple product varians)
      "//div[@id='buyNewSection']//span[contains(@class, 'offer-price')]//text()",
    ],
    :image => "//div[@id='imgTagWrapperId']/img/@data-old-hires",
  }
  CURRENCY = {
    :code => 'EUR',
    :symbol => '€',
  }

  def initialize
    super
    @currency = self.class::CURRENCY
  end

  def parse_name(name)
    name.to_s.strip
  end

  def parse_price(price)
    if not price.empty?
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
    item.merge! :currency => @currency[:code]
  end
end

class AmazonAU < AmazonBaseShop
  # Australia
  BASE_URL = 'https://amazon.au/dp/%s'
  CURRENCY = {
    :code => 'AUD',
    :symbol => '$',
  }
end

class AmazonBR < AmazonBaseShop
  # Brazil
  BASE_URL = 'https://amazon.com.br/db/%s'
  CURRENCY = {
    :code => 'R',
    :symbol => 'R$',
  }
end

class AmazonCA < AmazonBaseShop
  # Canada
  BASE_URL = 'https://amazon.com/dp/%s'
  CURRENCY = {
    :code => 'CDN',
    :symbol => 'CDN$',
  }
end

class AmazonCN < AmazonBaseShop
  # Canada
  BASE_URL = 'https://amazon.cn/dp/%s'
  CURRENCY = {
    :code => 'CNY',
    :symbol => '￥',
  }
end

class AmazonDE < AmazonBaseShop
  # Germany
  BASE_URL = 'https://amazon.de/dp/%s'
end

class AmazonES < AmazonBaseShop
  # Spain
  BASE_URL = 'https://amazon.es/dp/%s'
end

class AmazonFR < AmazonBaseShop
  # France
  BASE_URL = 'https://amazon.fr/dp/%s'
end

class AmazonIN < AmazonBaseShop
  # India
  BASE_URL = 'https://amazon.in/dp/%s'
  CURRENCY = {
    :code => 'INR',
    :symbol => '₹',
  }
end

class AmazonIT < AmazonBaseShop
  # Italy
  BASE_URL = 'https://amazon.it/dp/%s'
end

class AmazonJP < AmazonBaseShop
  # Japan
  BASE_URL = 'https://amazon.co.jp/dp/%s'
  CURRENCY = {
    :code => 'JPY',
    :symbol => '￥',
  }
end

class AmazonMX < AmazonBaseShop
  # Mexico
  BASE_URL = 'https://amazon.mx/dp/%s'
  CURRENCY = {
    :code => 'MXN',
    :symbol => '$'
  }
end

class AmazonNL < AmazonBaseShop
  # Netherlands
  BASE_URL = 'https://amazon.nl/dp/%s'
end

class AmazonUK < AmazonBaseShop
  # United Kingdom
  BASE_URL = 'https://amazon.co.uk/dp/%s'
  CURRENCY = {
    :code => 'GBP',
    :symbol => '£',
  }
end

class AmazonUS < AmazonBaseShop
  # United States
  BASE_URL = 'https://amazon.com/dp/%s'
  CURRENCY = {
    :code => 'USD',
    :symbol => '$',
  }
end
