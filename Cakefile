fs = require 'fs'

JAADI_VERSION = "1.0"

alreadyRan = no
{exec} = require 'child_process'

# define directories
target_dir = 'build'
target_app_dir = "#{target_dir}/js"

#recursively delete a folder
rmr = (path) ->
    if fs.existsSync path
        fs.readdirSync(path).forEach((file,index)->
            curPath = path + "/" + file

            if fs.statSync(curPath).isDirectory()
                rmr curPath
                fs.rmdirSync curPath, (err) ->
                    console.log err
            else
                fs.unlinkSync curPath
        )


cleanCreateFolder = (folder) ->
    fs.exists folder,(exists) ->
        if exists
            console.log "#{folder} exists. removing"
            rmr folder
        console.log "creating folder #{folder}" 
        createFolderIfNotExists folder

createFolderIfNotExists = (folder) ->
    fs.exists folder,(exists) ->
        if not exists
            fs.mkdir folder, (err,stdout,stderr) ->
                if err
                    console.log err

task 'create:target', 'create target folder', ->
    #remove the complete {target} folder
    rmr target_dir

    #create {target}/
    console.log "creating #{target_dir}"
    createFolderIfNotExists target_dir

    #create {target}/app
    console.log "creating #{target_dir}"
    createFolderIfNotExists "#{target_dir}/app"

    #create {target}/js
    console.log "creating #{target_app_dir}"
    createFolderIfNotExists target_app_dir

task 'create:merge-sources', 'merge all CS files into one', ->
    files = [
        'jaadi-1.0',
        'storage.jaadi'
    ]

    single_src = "#{target_app_dir}/jaadi-#{JAADI_VERSION}.coffee"

    contents = new Array 
    remaining = files.length

    for file, index in files then do (file, index) ->
        fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
          throw err if err
          contents[index] = fileContents

          #chaining process fn here
          process() if --remaining is 0

    process = ->
        fs.writeFile single_src, contents.join('\n\n'), 'utf8', (err) ->
          throw err if err
          exec "coffee --compile --bare #{single_src}", (err, stdout, stderr) ->
            throw err if err
            console.log stdout + stderr
            fs.unlink single_src, (err) ->
              throw err if err
              console.log 'Done.'

task 'create:merge-sources-1', 'merge all CS files into one', ->
    files = [
        'jaadi-1.0',
        'storage.jaadi'
    ]

    single_src = "#{target_dir}/app/jaadi-#{JAADI_VERSION}.coffee"

    contents = new Array 
    remaining = files.length

    for file, index in files then do (file, index) ->
        fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
          throw err if err
          contents[index] = fileContents

          #chaining process fn here
          process() if --remaining is 0

    process = ->
        fs.writeFile single_src, contents.join('\n\n'), 'utf8', (err) ->
          throw err if err

task 'compile:all', 'copy dependencies', ->
    
    exec "coffee --compile --bare --output  #{target_dir}/js #{target_dir}/app", (err, stdout, stderr) ->
        throw err if err
        

task 'copy:dependencies', 'copy dependencies', ->
    
    files = [
        'bst.jaadi'
    ]

    for file, index in files then do (file, index) ->
        fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
            throw err if err
            fs.writeFile "#{target_dir}/app/#{file}.coffee",fileContents, 'utf8', (err) ->
                throw err if err

ncp = require('ncp').ncp

task 'copy:tests', 'copy dependencies', ->
    ncp 'tests', 'build/tests/'

task 'compile', 'copy dependencies', ->
    invoke 'create:target'
    invoke 'create:merge-sources-1'
    invoke 'copy:dependencies'
    invoke 'compile:all'
    invoke 'copy:tests'

task 'create:distro', 'create distro', ->
    invoke 'create:target'
    invoke 'create:merge-sources'
    #invoke 'copy:dependencies'
