requestAmp = require '../src/request'
request = requestAmp.request
{app} = require './app.test'
utils = require '../src/utils'

chai = require 'chai'
should = chai.should()

describe 'Request', ->

  before ->
    app.listen 3000

  it 'should define a resource', ->
    request.define 'getProducts', 'ajax',
      url: 'http://localhost:3000/products'
      dataType: 'json'
      type: 'GET'
    # No error is good enough to pass here

  it 'should define a resource with a substitution URL', ->
    request.define 'getProduct', 'ajax',
      url: 'http://localhost:3000/products/{id}'
      dataType: 'json'
      type: 'GET'
    # No error is good enough to pass here

  it 'should work with request parameters', (done) ->
    request 'getProducts', (data) ->
      should.exist data
      done()

  it 'should work with request settings', (done) ->
    request
      resourceId: 'getProducts'
      success: (data) ->
        should.exist data
        done()

  it 'should return JSON when the dataTyee is set to \'json\'', (done) ->
    request
      resourceId: 'getProducts'
      success: (data) ->
        utils.getType(data).should.be.equal 'object'
        done()


  it 'should work with request url substitution', (done) ->
    expected = '11223344'

    request
      resourceId: 'getProduct'
      data:
        id: expected
      success: (data) ->
        should.exist data.id, 'product.id'
        data.id.should.equal expected
        done()


  it 'should throw unknown resource if resourceId is not found', ->
    resourceId = 'nonExistingResource'
    (-> request resourceId).should.throw "unknown resourceId: #{resourceId}"

  describe 'Successful Request', ->
    resultData = null
    it 'should call the success callback function', (done) ->
      request
        resourceId: 'getProducts'
        success: (data) ->
          resultData = data
          done()
    it 'should return data to the success callback', ->
      should.exist resultData

  describe 'Error Request', ->
    resultError = null
    it 'should call the error callback function', (done) ->
      request.define 'getProductsError', 'ajax',
        url: 'http://localhost:300r/error'
        dataType: 'json'
        type: 'GET'

      request
        resourceId: 'getProductsError'
        error: (error) ->
          resultError = error
          done()
    it 'should return the error to the callback', ->
      should.exist resultError