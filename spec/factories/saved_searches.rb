FactoryBot.define do
  factory :saved_search do
    name { "Name" }
    category { FactoryBot.build(:category) }
    account { FactoryBot.build(:account) }
  end
end
