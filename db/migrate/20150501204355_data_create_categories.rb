class DataCreateCategories < ActiveRecord::Migration
  def change
    Category.create!(name: 'Теннис', parent: Category.where(name: 'Стадион').first)
    Category.create!(name: 'Групповые занятия')
    Category.create!(name: 'Йога')
    Category.create!(name: 'Фитнесс')
  end
end
