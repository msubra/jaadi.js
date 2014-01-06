fs = require 'fs'

JAADI_VERSION = "1.0"

ncp = require('ncp').ncp
ncp.limit = 16;
alreadyRan = no
{exec} = require 'child_process'

# define directories
target_dir = 'target'
target_app_dir = "#{target_dir}/js"
build_dir = 'build'

task 'create:target', 'create target folder', ->
    fs.mkdir "#{target_dir}"
    fs.mkdir "#{target_app_dir}"

task 'create:build', 'create target folder', ->
    fs.mkdir "#{build_dir}"

task 'copy:dependencies', 'copy dependencies', ->
    #create target folders
    invoke 'create:target'

    ncp "js/",target_app_dir
    ncp "js/",build_dir

    #dependencies = []

    #for file in dependencies
    #    fs.createReadStream(file).pipe(fs.createWriteStream("#{target_app_dir}/#{file}"));

task 'create:dist', 'create distro', ->
    console.log 'Creating dir ./dist'

    invoke 'create:target'
    invoke 'create:build'

    invoke 'copy:dependencies'
