FactoryBot.define do
  factory :user do
    name { 'Bom Dia' }
    is_admin { false }
    email { 'bom@dia' }
    password { '123456' }
  end
end
