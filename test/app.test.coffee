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
  next()

app = restify.createServer()
app.use restify.bodyParser()

app.get '/products', respond
app.head '/products', respond

app.get '/products/:id', respond
app.head '/products/:id', respond

app.post '/products', (req, res, next) ->
  res.send 200, req.body
  next()

app.put '/products/:id', (req, res, next) ->
  result = req.body
  result.id = req.params.id
  res.send 200, result
  next()

app.del '/products/:id', (req, res, next) ->
  res.send 200
  next()

exports.app = app