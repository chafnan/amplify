###
  Routes
  -----------------------------------------------
  |Resource         | GET | POST | PUT | DELETE |
  |---------------------------------------------|
  | /products/:id   |  X  |      |     |        |
  |---------------------------------------------|
###

restify = require 'restify'

respond = (request, response, next) ->
  response.send
    id: request.params.id ? 1234
    name: 'fake product'
    description: 'fake description'

app = restify.createServer()

app.get '/products', respond
app.head '/products', respond

app.get '/products/:id', respond
app.head '/products/:id', respond

exports.app = app