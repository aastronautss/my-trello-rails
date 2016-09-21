Fabricator :comment do
  body { Faker::Lorem.paragraph }
  author { User.any? ? User.all.sample : Fabricate(:user) }
  card { Card.any? ? Card.all.sample : Fabricate(:card) }
end
