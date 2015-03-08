Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
  options[:AWS_secret_key] = ENV['AWS_SECRET_KEY']
  options[:associate_tag] = ENV['AMAZON_ASSOCIATE_TAG']
end

module AmazonElementExtentions
  def to_hash
    hash = Hash.from_xml(to_s).try(:values).try(:first) || {}
    set_authors_to(hash)
    hash
  end

  def to_json
    to_hash.to_json
  end

  private

  def set_authors_to(hash)
    destination_item_attributes = hash['ItemAttributes']
    return false unless destination_item_attributes

    source_item_attributes = get_element('ItemAttributes')
    return false unless source_item_attributes

    destination_item_attributes['Authors'] = source_item_attributes.get_array('Author')
  end
end

Amazon::Element.send(:include, AmazonElementExtentions)
