json.id card.to_param
json.list_id card.list_id

json.title card.title
json.description card.description
json.position card.position

json.activities card.activities[:items]
