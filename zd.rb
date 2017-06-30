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
	puts "Usage: zd.rb »command« »terms or id«"
	puts "Command can be search, ticket, user, or org"
end

# perform a generic search for anything
def search(client, terms)
	search_terms = terms.join(' ')
	return client.search(:query => search_terms)
end

# return a user object by ID
def finduser(client, id)
	client.user.find(:id => id)
end

# return an org object by ID
def findorg(client, id)
	return client.organization.find(:id => id)
end

# Build a ticket project in TaskPaper format (mostly for OmniFocus import)
def ticketproject(client, id)
	ticket = client.ticket.find!(:id => id, :include => :users)
	org = client.organization.find!(:id => ticket.organization.id)
	contact = ticket.requester.name
	duration = ""
	if ticket.priority == "High" 
		duration = "4 hours"
	end
	if ticket.priority == "Urgent"
		duration = "30 minutes"
	end
	if duration != ""
		priority_text = "- #{id}: Send simple initial response within #{duration} of SLA: «Priority»  @context(Work : Ticket Duties)\n"
	else
		priority_text = ""
	end
	puts "#{id}: #{ticket.subject}
    #{org.name.to_s}
    #{contact}: #{ticket.requester.email}
    Original priority: #{ticket.priority}
#{priority_text}- #{id}: Send a response based on ticket @context(Work : Ticket Duties)
- #{id}: Wait to hear from #{contact} @context(Work : Waiting For)
- #{id}: Set ticket to solved @context(Work : Ticket Duties)"
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
	when "search" # generic search, doesn't work for "id:"
		search(client, ARGV).each { |elt| jj elt }
	when "user"
		jj finduser(client, ARGV[0]) # TODO: should probably do a usage check on the number of args
	when "org"
		jj findorg(client, ARGV[0])  # TODO: another usage check
	when "ticketproject"
		puts ticketproject(client, ARGV[0])
	else
		usage()
end
