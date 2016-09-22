json.id comment.id
json.card_id comment.card_id
json.body format_body(comment.body)
json.created_at comment.created_at

json.author do
  json.username comment.author.username
  json.path user_path(comment.author)
end
