class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.translated_enums(*attributes)
    attributes.each do |attr|
      define_method("translated_#{attr}") do
        self.class.human_enum_name(attr, send(attr))
      end
    end
  end

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name
           .i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end
