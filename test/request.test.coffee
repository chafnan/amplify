requestAmp = require '../src/request'
request = requestAmp.request
{app} = require './app.test'
utils = require '../src/utils'

chai = require 'chai'
should = chai.should()

describe 'Request', ->

  before ->
    app.listen 3000

  describe 'request( resourceId, [hash data], [function callback]] )', ->

    describe 'define( string resourceId, [string type], [hash settings] )', ->
      expectedResourceId = 'testResource'
      expectedType = 'ajax'
      expectedSettings =
        url: '/testDefine'
        dataType: 'json'
        type: 'GET'

      it 'should add resource', ->
        request.define expectedResourceId, expectedType, expectedSettings

        resource = request.resources[expectedResourceId]

        should.exist resource
        resource.type.should.be.equal expectedType
        resource.settings.should.be.equal expectedSettings

      it 'should throw an error if resourceId parameter not defined', ->
        (-> request.define null, expectedType, expectedSettings).should.throw 'resourceId is required'

      it 'should throw an error if type parameter is not defined', ->
        (-> request.define expectedResourceId, null, expectedSettings).should.throw 'type is required'

      it 'should throw an error if the type function is not defined', ->
        (-> request.define expectedResourceId, 'fakeType', expectedSettings).should.throw 'type is not defined'

    describe 'Success Calls', ->
      before ->
        request.define 'getProducts', 'ajax',
          url: 'http://localhost:3000/products'
          dataType: 'json'
          type: 'GET'

        request.define 'headProducts', 'ajax',
          url: 'http://localhost:3000/products'
          dataType: 'json'
          type: 'HEAD'

        request.define 'getProduct', 'ajax',
          url: 'http://localhost:3000/products/{id}'
          dataType: 'json'
          type: 'GET'

        request.define 'postProduct', 'ajax',
          url: 'http://localhost:3000/products'
          dataType: 'json'
          type: 'POST'

        request.define 'postProductXml', 'ajax',
          url: 'http://localhost:3000/products'
          dataType: 'xml'
          type: 'POST'

        request.define 'putProduct', 'ajax',
          url: 'http://localhost:3000/products/{id}'
          dataType: 'json'
          type: 'PUT'

        request.define 'deleteProduct', 'ajax',
          url: 'http://localhost:3000/products/{id}'
          dataType: 'json'
          type: 'DELETE'

      it 'should GET using parameters', (done) ->
        request 'getProducts', (data, status) ->
          status.should.be.equal 'success'
          should.exist data
          done()

      it 'should get using settings', (done) ->
        request
          resourceId: 'getProducts'
          success: (data, status) ->
            status.should.be.equal 'success'
            should.exist data
            done()

      it 'should GET a single resource', (done) ->
        expectedId = '123456789'

        request
          resourceId: 'getProduct'
          data:
            id: expectedId
          success: (data, status) ->
            status.should.be.equal 'success'
            data.id.should.be.equal expectedId
            done()

      it 'should POST content type of XML'

      it 'should POST content type of JSON', (done) ->
        expectedId = 'postId'
        expectedName = 'postName'
        expectedDescription = 'postDescription'

        request
          resourceId: 'postProduct'
          data:
            id: expectedId
            name: expectedName
            description: expectedDescription
          success: (data, status) ->
            status.should.be.equal 'success'
            data.id.should.be.equal expectedId
            data.name.should.be.equal expectedName
            data.description.should.be.equal expectedDescription
            done()

      it 'should PUT', (done) ->
        expectedId = 'putId'
        expectedName = 'putName'
        expectedDescription = 'putDescription'

        request
          resourceId: 'putProduct'
          data:
            id: expectedId
            name: expectedName
            description: expectedDescription
          success: (data, status) ->
            status.should.be.equal 'success'
            data.id.should.be.equal expectedId
            data.name.should.be.equal expectedName
            data.description.should.be.equal expectedDescription
            done()

      it 'should DELETE', (done) ->
        request
          resourceId: 'deleteProduct'
          data:
            id: 'deleteId'
          success: (data, status) ->
            status.should.be.equal 'success'
            should.exist data
            done()


      it 'should HEAD', (done) ->
        request
          resourceId: 'headProducts'
          success: (data, status) ->
            status.should.be.equal 'success'
            done()

    describe 'Error calls', ->
      before ->
        request.define 'getErrors', 'ajax',
          url: 'http://localhost:300/errors'
          dataType: 'json'
          type: 'GET'

        request.define 'headError', 'ajax',
          url: 'http://localhost:300/errors'
          dataType: 'json'
          type: 'HEAD'

        request.define 'getError', 'ajax',
          url: 'http://localhost:300/errors/{id}'
          dataType: 'json'
          type: 'GET'

        request.define 'postError', 'ajax',
          url: 'http://localhost:300/errors'
          dataType: 'json'
          type: 'POST'

        request.define 'putError', 'ajax',
          url: 'http://localhost:300/errors/{id}'
          dataType: 'json'
          type: 'PUT'

        request.define 'deleteError', 'ajax',
          url: 'http://localhost:300/errors/{id}'
          dataType: 'json'
          type: 'DELETE'

      it 'should GET', (done) ->
        request
          resourceId: 'getErrors'
          error: (error, status) ->
            status.should.be.equal 'error'
            should.exist error
            done()

      it 'should POST', (done) ->
        request
          resourceId: 'postError'
          data:
            id: 1234
          error: (error, status) ->
            status.should.be.equal 'error'
            should.exist error
            done()

      it 'should PUT', (done) ->
        request
          resourceId: 'putError'
          data:
            id: 1234
          error: (error, status) ->
            status.should.be.equal 'error'
            should.exist error
            done()

      it 'should DELETE', (done) ->
        request
          resourceId: 'deleteError'
          data:
            id: 1234
          error: (error, status) ->
            status.should.be.equal 'error'
            should.exist error
            done()

      it 'should HEAD', (done) ->
        request
          resourceId: 'headError'
          data:
            id: 1234
          error: (error, status) ->
            status.should.be.equal 'error'
            should.exist error
            done()