# frozen_string_literal: true
# encoding: UTF-8

module CategoryConcern
  extend ActiveSupport::Concern

  # Концерн предоставляет возможность работать с категориями объекта
  # Работает совместно с концерном TaggableConcern

  included do

    # Найти объекты, принадлежащие катеории с именем category_name
    scope :by_category, ->(category_name){ joins(:tags).where(tags: { name: category_name, tag_type: 'category' }) }
  end


  # Вернуть все категории на которые ссылается объект
  def category_tags
    self.tags.category
  end

  def add_category(category_name)
    category = Tag.category.find_by_name(category_name)
    raise StandardError, "Not found category with name #{category_name}" if category.nil?

    self.tags << category unless self.has_category?(category_name)
  end

  def delete_category(category_name)
    category = self.category_tags.find_by_name(category_name)
    raise StandardError, "Not found category with name #{category_name}" if category.nil?

    self.tags.delete(category)
  end

  def has_category?(category_name)
    !self.category_tags.find_by_name(category_name).nil?
  end

  def clear_categories
    category_names = self.category_tags.map(&:name)
    category_names.each do |category_name|
      self.delete_category(category_name)
    end
  end
end
