json.id card.to_param
json.list_id card.list.to_param

json.title card.title
json.description card.description
json.position card.position

json.checklists card.checklists[:lists]
json.activities card.activities[:items]

json.watching current_user.watching?(card)
