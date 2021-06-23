FactoryBot.define do
  factory :painting do
    painter { nil }
    style { nil }
    name { 'Mona Lisa' }
    time_of_completion { '1506-02-18' }
  end
end
