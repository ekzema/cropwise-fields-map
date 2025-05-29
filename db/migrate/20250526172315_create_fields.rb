class CreateFields < ActiveRecord::Migration[8.0]
  def change
    enable_extension "postgis" unless extension_enabled?("postgis")

    create_table :fields do |t|
      t.string :name
      t.float :area
      t.multi_polygon :shape, geographic: true, srid: 4326

      t.timestamps
    end
  end
end
