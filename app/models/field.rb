class Field < ApplicationRecord
  validates :name, :shape, presence: true

  after_save :update_area_from_db

  private

  def update_area_from_db
    self.update_column(
      :area,
      Field.where(id: self.id).pluck(
        Arel.sql("ST_Area(shape::geography)")
      ).first
    )
  end
end
