require 'sinatra'
require 'json'
require_relative 'middleware/git'
require_relative 'middleware/pivotal'

post '/pr' do
  p "posting...."
  payload = JSON.parse(request.body.read)
  @git = Middleware::Git.new payload
  return "pull request not merged" if @git.nil?
  @pivotal = Middleware::Pivotal.new 
  @pivotal.pr @git
end
