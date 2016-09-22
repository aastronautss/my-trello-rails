Fabricator :list do
  title { Faker::Lorem.words(rand 1..4).join ' ' }
  board { Board.any? ? Board.all.sample : Fabricate(:board) }
end
