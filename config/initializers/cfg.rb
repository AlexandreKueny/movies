# encoding: utf-8
require 'erb'
require 'yaml'

# load the configuration file (YAML files) into CFG
# Could be accessed by CFG['name']['name2']....
# and CFG.name.name2
CFG = Hashie::Mash.new(YAML.load(ERB.new(IO.read(File.join(Rails.root, 'config', 'config.yml'))).result)[Rails.env])
