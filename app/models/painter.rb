class Painter < ApplicationRecord
  validates :name, :bio, :born, :died, presence: :true
  validates_length_of :name, minimum: 3
  validates_length_of :bio, minimum: 30
  validates :born, length: { is: 10 }
  validates :died, length: { is: 10 }
  validate :valid_date
  has_many :paintings, dependent: :destroy
  has_one_attached :photo

  def valid_date
    if born.blank? || died.blank?
      errors.add :born, 'Data inválida'
    elsif died.blank?
      errors.add :died, 'Data inválida'
    elsif born.after? died
      errors.add :born, 'Data inválida'
    end
  end
end
