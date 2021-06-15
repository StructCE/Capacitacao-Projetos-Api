class Painter < ApplicationRecord
    validates :name, :bio, :born, :died, presence: :true 
    validates_length_of :name, minimum: 3
    validates_length_of :bio, minimum: 30
    validates :born, length: { is: 10 }
    validates :died, length: { is: 10 }
    validate :valid_date

    def valid_date
        if born.blank?
            self.errors.add :born, 'Data inválida'
        elsif died.blank? 
            self.errors.add :born, 'Data inválida'
        elsif born.after? died
            self.errors.add :born, 'Data inválida'
        end
    end
end
