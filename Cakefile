fs = require 'fs'
path = require 'path'
Amplify = require './src/amplify'
{exec} = require 'child_process'

# Built file header
header = """
   /*
    * Amplify v#{Amplify.VERSION}
    * http://coffeescript.org
    *
    * Copyright 2011, Jonathan Chapman
    * Released under the MIT License
    */
"""

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/amplify src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr if stdout and stderr

