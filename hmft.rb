# coding: utf-8
require 'open-uri'

require 'nokogiri'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if settings.development?

HTTP_HEADERS = {
  'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36'
}

class Shop
  def initialize(base_url, field_xpath={})
    @base_url = base_url
    @field_xpath = field_xpath
  end

  def download_url_contents(url)
    open(url, HTTP_HEADERS) {|handler| handler.read}
  end

  def get_item_info_from_id(id)
    contents = download_url_contents(@base_url % [id])
    retrieve_info_from_contents contents
  end

  def retrieve_info_from_contents(contents)
    @doc = Nokogiri::HTML contents
    item = {}
    @field_xpath.each do |key, value|
      if not value.is_a? Enumerable
        item[key] = parse_field(key, @doc.xpath(value))
      else
        value.each do |xpath|
          field_value = @doc.xpath(xpath)
          if not field_value.empty?
            item[key] = parse_field(key, field_value) if not field_value.empty?
            break
          end
        end
      end
    end
    parse_item item
  end

  def parse_field(key, value)
    method_name = "parse_%s" % key
    return self.send(method_name, value) if self.class.method_defined? method_name
    value
  end

  def parse_item(item)
    item
  end
end

class Amazon < Shop
  @base_url = 'https://amazon.%s/dp/%s'
  @@field_xpath = {
    :name => "//span[@id='productTitle']//text()",
    :price => [
      # Main content price
      "//span[@id='priceblock_ourprice']//text()",
      # Right block price (when multiple product varians)
      "//div[@id='buyNewSection']//span[contains(@class, 'offer-price')]//text()",
    ],
    :image => "//div[@id='imgTagWrapperId']/img/@data-old-hires",
  }

  def initialize(tld, currency = 'EUR', currency_symbol = '€')
    super("https://amazon.#{tld}/dp/%s", @@field_xpath)
    @currency = {
      :code => currency,
      :symbol => currency_symbol,
    }
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
  end

  def parse_item(item)
    item.merge! :currency => @currency[:code]
  end
end

shops = {
  :amazonau => Amazon.new('au', 'AUD', '$'),
  :amazonbr => Amazon.new('com.br', 'R', 'R$'),
  :amazonca => Amazon.new('ca', 'CDN', 'CDN$'),
  :amazoncn => Amazon.new('cn', 'CNY', '￥'),
  :amazonde => Amazon.new('de'),
  :amazones => Amazon.new('es'),
  :amazonfr => Amazon.new('fr'),
  :amazonin => Amazon.new('in', 'INR', '₹'),
  :amazonit => Amazon.new('it'),
  :amazonjp => Amazon.new('co.jp', 'JPY', '￥'),
  :amazonmx => Amazon.new('mx', 'MXN', '$'),
  :amazonnl => Amazon.new('nl'),
  :amazonuk => Amazon.new('co.uk', 'GBP', '£'),
  :amazonus => Amazon.new('com', 'USD', '$'),
}

get '/:shop_name/:id' do |shop_name, id|
  if shops.key?(shop_name.to_sym) then
    shop = shops[shop_name.to_sym]
    item = shop.get_item_info_from_id(id)
    json item
  else
    status 404
  end
end
