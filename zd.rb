#!/usr/bin/env ruby

# Provide some command line functions for ZenDesk
# Search
#
# Bill Smargiassi
# 2017-06-27

require "zendesk_api"
require "string-scrub"
require "json"

def usage
	puts "Usage: zd.rb »command«"
	puts "Command can be 'search'"
end

def search(client, terms)
	search_terms = terms.join(' ')
	return client.search(:query => search_terms)
end

def finduser(client, id)
	client.user.find(:id => id)
end

def findorg(client, id)
	return client.organization.find(:id => id)
end

jconfig = JSON.parse(File.read(ENV['HOME'] + "/.zdapi.json"))

client = ZendeskAPI::Client.new do |config|
	config.url = jconfig["url"]
	config.username = jconfig["username"]
	config.token = jconfig["token"]
	config.retry = true
end

command = ARGV.shift

# Process commands
case command
	when "search" 
		search(client, ARGV).each { |elt| jj elt }
	when "user"
		jj finduser(client, ARGV[0]) # TODO: should probably do a usage check on the number of args
	when "org"
		jj findorg(client, ARGV[0])  # TODO: another usage check
	else
		usage()
end
