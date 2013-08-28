http = require 'http'
https = require 'https'
url = require 'url'
utils = require './utils'

replacePathTemplates = (pathname, data) ->
  return unless data?

  path = pathname
  matches = path.match /{[\w\d]*}/g

  if not matches?
    return path

  for match in matches
    prop = match.replace('{','').replace('}','')
    replaceValue = data[prop]
    path = path.replace(match, replaceValue) if replaceValue?

  return path

request = (resourceId, data, callback) ->
  settings = resourceId || {}

  if utils.isType resourceId, 'string'
    if utils.isType data, 'function'
      callback = data
      data = {}
    settings =
      resourceId: resourceId
      data: data || {}
      success: callback

  resource = resources[settings.resourceId]
  throw "unknown resourceId: #{settings.resourceId}" unless resource?

  resource.settings.data = settings.data || {}
  resource.settings.success = settings.success
  resource.settings.error = settings?.error

  console.log
  if utils.isType(resource.type, 'function')
    resource.type resource.settings
  else
    types[resource.type](resource.settings)

exports.request = request

define = (resourceId, type, settings = {}) ->
  throw 'resourceId is required' unless resourceId?
  throw 'type is required' unless type?
  throw 'type is not defined' unless types[type]? || utils.isType(type, 'function')

  resources[resourceId] =
    type: type
    settings: settings

exports.request.define = define

resources = {}
exports.request.resources = resources

types = []
exports.request.types = types

types.ajax = (settings) ->

  # Set Defaults
  settings.type ?= 'GET'

  # Split the url into parts
  urlParts = url.parse settings.url

  options =
    hostname: urlParts.hostname
    port: urlParts.port
    path: replacePathTemplates(urlParts.pathname, settings.data)
    method: settings.type
    headers:
      'content-type': if settings.dataType is 'json' then 'application/json' else 'text/xml'

  ampXHR =
    setRequestHeader: (key, value) ->
      options.headers[key] = value

  data = ''
  req = null

  requestFunction = (res) ->

    res.on 'data', (chunk) ->
      data += chunk
    res.on 'end', ->
      data = JSON.parse(data) if settings.dataType is 'json' and data isnt ''
      settings.success data, 'success' if settings.success?
    res.on 'error', (err) ->
      settings.error err, 'error' if settings.error?

  settings.beforeSend? ampXHR, settings

  req =
      if urlParts.protocol is 'https'
        https.request options, requestFunction
      else
        http.request options, requestFunction

  req.on 'error', (err) ->
    settings.error err, 'error' if settings.error?

  req.write JSON.stringify(settings.data) if options.method is 'POST' or options.method is 'PUT'

  req.end()