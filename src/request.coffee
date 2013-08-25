http = require 'http'
https = require 'https'
url = require 'url'
utils = require './utils'

@settings
@resource

resources = {}

isSecure = (protocol) ->
  protocol is 'https'

onSuccess = (data) ->
  data = JSON.parse(data) if @resource.settings.dataType is 'json'
  @settings.success data, 'success' if @settings.success?

onError = (error) ->
  @settings.error error, 'error' if @settings.error?

writeData = (req) ->
  req.write @settings.data if not @settings.data? and @settings.data isnt {} and @settings.data isnt undefined

requestFunction = (res) ->
  data = ''
  res.on 'data', (chunk) ->
    data += chunk
  res.on 'end', ->
    onSuccess data
  res.on 'error', (err) ->
    onError err

callRequest = (options, isSecure) ->
  req = null

  if isSecure
    req = https.request options, requestFunction
  else
    req = http.request options, requestFunction

  req.on 'error', (err) ->
    onError err

  writeData req
  req.end()

replacePathTemplates = (pathname) ->
  path = pathname
  matches = path.match /{[\w\d]*}/g

  if not matches?
    return path

  for match in matches
    prop = match.replace('{','').replace('}','')
    replaceValue = @settings?.data[prop]
    path = path.replace(match, replaceValue) if replaceValue?

  return path

request = (resourceId, data, callback) ->
  @settings = resourceId || {}

  if utils.isType resourceId, 'string'
    if utils.isType data, 'function'
      callback = data
      data = {}
    @settings =
      resourceId: resourceId
      data: data || {}
      success: callback

  @resource = resources[@settings.resourceId]
  throw "unknown resourceId: #{@settings.resourceId}" if not @resource?

  urlParts = url.parse @resource.settings.url

  options =
    hostname: urlParts.hostname
    port: urlParts.port
    path: replacePathTemplates(urlParts.pathname)
    method: @resource.settings.type

  callRequest options, isSecure(urlParts)

define = (resourceId, type, settings) ->
  resources[resourceId] =
    type: type
    settings: settings

exports.request = request
exports.request.define = define