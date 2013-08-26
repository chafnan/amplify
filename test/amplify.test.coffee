amplify = require '../src/amplify'

chai = require 'chai'
should = chai.should()

describe 'Amplify', ->
  it 'should expose request', ->
    should.exist amplify.request

  it 'should show the verison', ->
    should.exist amplify.version