Fabricator :plan do
  name { Faker::Lorem.word }
  price_per_month { rand(399..1099) }
end

Fabricator :plus_plan, from: :plan do
  name 'Plus'
  price_per_month 399
  stripe_plan_id 'my_trello_plus_monthly'
end

Fabricator :basic_plan, from: :plan do
  name 'Basic'
  price_per_month 0
end
