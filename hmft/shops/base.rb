class Shop
  @@shops = {}

  ABSTRACT = false
  BASE_URL = nil
  FIELD_XPATH = {}

  def initialize
    @base_url = self.class::BASE_URL
    @field_xpath = self.class::FIELD_XPATH
  end

  def self.shops
    @@shops
  end

  def self.inherited(cls)
    # Register shops
    @@shops[cls.name.downcase.to_sym] = cls.new unless cls.name.include? 'Base'
  end

  def download_url_contents(url)
    open(url, HTTP_HEADERS).map(&:read)
  end

  def get_item_info_from_id(id)
    contents = download_url_contents(format(@base_url, id))
    retrieve_info_from_contents contents
  end

  def retrieve_info_from_contents(contents)
    @doc = Nokogiri::HTML contents
    item = {}
    @field_xpath.each do |key, value|
      if !value.is_a? Enumerable
        item[key] = parse_field(key, @doc.xpath(value))
      else
        value.each do |xpath|
          field_value = @doc.xpath(xpath)
          unless field_value.empty?
            item[key] = parse_field(key, field_value)
            break
          end
        end
      end
    end
    parse_item item
  end

  def parse_field(key, value)
    method_name = format('parse_%s', key)
    return send(method_name, value) if self.class.method_defined? method_name
    value
  end

  def parse_item(item)
    item
  end
end
