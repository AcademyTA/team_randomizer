require 'sinatra'

enable :sessions

get "/" do
  erb :index, layout: :default
end

post "/" do
  session[:number]       = params["number"].to_i
  session[:members]      = params["members"].scan(/[0-9A-Za-z]+/).shuffle
  session[:method]       = params["method"]
  session[:member_count] = session[:members].count
  session[:results]      = choose_randomizer
  erb :index, layout: :default
end

def choose_randomizer
  if session[:method] == "members"
    team_count = (session[:members].count / session[:number].to_f).ceil
    member_randomizer(team_count)
  else
    team_randomizer
  end
end

def team_randomizer
  teams = Array.new(session[:number]) { Array.new }

  while session[:members].count > 0
    teams.each { |team| team.push(session[:members].pop) unless session[:members].empty? }
  end

  teams.each_with_index.inject({}) do |result, (team, index)|
    result[index + 1] = team.join(', ')
    result
  end
end

def member_randomizer(team_count)
  teams = Array.new
  team_count.times { teams << session[:members].shift(session[:number]) }

  teams.each_with_index.inject({}) do |result, (team, index)|
    result[index + 1] = team.join(', ')
    result
  end
end
