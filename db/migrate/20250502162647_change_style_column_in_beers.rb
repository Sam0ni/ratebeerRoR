class ChangeStyleColumnInBeers < ActiveRecord::Migration[8.0]
  def up
    rename_column :beers, :style, :old_style
    add_reference :beers, :style

    Beer.reset_column_information

    Beer.find_each do |beer|
      matched_style = Style.find_by(name: beer.old_style)
      beer.update_column(:style_id, matched_style&.id)
    end
  end

  def down
    remove_reference :beers, :style
    rename_column :beers, :old_style, :style
  end
end
