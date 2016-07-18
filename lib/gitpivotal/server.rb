require 'sinatra'
require 'json'
require_relative 'middleware/git'
require_relative 'middleware/pivotal'
require "sinatra/reloader" if development?

set :enviroment, :production
set :port, 8080

post '/pr' do
  # handle webhook payload
  payload = JSON.parse(request.body.read)
  return "ping successfull" if payload.has_key?('zen')
  # extract information from payload
  @git = Middleware::Git.new payload
  return "pull request not merged" if @git.nil?

  # Send PR information to Pivotal handler
  @pivotal = Middleware::Pivotal.new
  begin
    res = @pivotal.pr @git.pr
  rescue Exception => e
    p e.inspect
    return "Error occurred: #{e.message}"
  end

  # notify client
  if res[:status] != 200
    "Error occurred: #{res[:error]}"
  else
    res[:status]
  end
end