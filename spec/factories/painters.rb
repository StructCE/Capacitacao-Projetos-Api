FactoryBot.define do
  factory :painter do
    name { 'Michelangelo' }
    bio do
      "Conhecido como um dos maiores pintores do mundo, Michelangelo se destaca por suas obras 'Capela Sistina', 'Juízo Final' e entre diversas outras. "
    end
    born { '1475-03-06' }
    died { '1564-02-18' }
  end
end
