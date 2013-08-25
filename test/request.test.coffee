describe 'Request', ->
  it 'should define a resource'
  it 'should use a resource to make a request'
  it 'should work with request parameters'
  it 'should work with request settings'

  describe 'Successful Request', ->
    it 'should call the success callback function'
    it 'should return data to the success callback'

  describe 'Error Request', ->
    it 'should call the error callback function'
    it 'should return the error to the callback'