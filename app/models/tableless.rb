class Tableless
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :new_record

  def initialize(attributes={})
   self.new_record = attributes.blank?
   attributes && attributes.each do |name, value|
     send("#{name}=", value) if respond_to? name.to_sym
   end
  end

  def new_record?
    return self.new_record
  end

  def persisted?
    false
  end

  def self.inspect
    if self.respond_to?(:attributes)
      "#<#{self.to_s} #{self.attributes.collect{ |e| ":#{ e }" }.join(', ')}>"
    else
      "#<#{self.to_s}>"
    end
  end
end
