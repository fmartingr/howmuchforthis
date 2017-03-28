# coding: utf-8
require 'open-uri'

require 'nokogiri'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if settings.development?

# Require all shops
Dir.glob(File.dirname(File.expand_path(__FILE__)) + '/shops/*').each {|file|
  require_relative file if not file.include? 'base'
}

HTTP_HEADERS = {
  'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36'
}

get '/:shop_name/:id' do |shop_name, id|
  begin
    if Shop.shops.key?(shop_name.to_sym) then
      shop = Shop.shops[shop_name.to_sym]
      item = shop.get_item_info_from_id(id)
      json item
    end
  rescue
    status 404
  end
end
