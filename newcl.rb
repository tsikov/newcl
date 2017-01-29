require 'rb-readline'
require 'pry'
require 'net/http'
require 'json'
require 'colorize'

# this function is needed to handle redirects
def fetch(uri_str, limit = 10)
  # You should choose a better exception.
  raise ArgumentError, 'too many HTTP redirects' if limit == 0

  response = Net::HTTP.get_response(URI(uri_str))

  case response
  when Net::HTTPSuccess then
    response
  when Net::HTTPRedirection then
    location = response['location']
    warn "redirected to #{location}"
    fetch(location, limit - 1)
  end
end

def fetch_repos
  puts "fetching new repos"
  result = fetch("https://api.github.com/search/repositories?q=language:common-lisp+created%3A%3E2017-01-01")
  json = JSON.parse result.body
  json["items"].map { |r| [r["created_at"], r["description"], r["html_url"]] }
end

def print_repos(repos)
  repos.each do |r|
    r[1] ||= "No description provided"
    puts r[1].red
    puts r[2].yellow
  end
end

repos = fetch_repos
print_repos(repos)

