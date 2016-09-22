Fabricator :card do
  title { Faker::Lorem.words(rand 1..4).join ' ' }
  description { Faker::Lorem.paragraph }
  list { List.any? ? List.all.sample : Fabricate(:list) }
end
