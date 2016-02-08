require 'sinatra'

enable :sessions

get "/" do
  erb :index, layout: :default
end

post "/" do
  session[:teams]        = params["teams"].to_i
  session[:members]      = params["members"].scan(/[0-9A-Za-z]+/).shuffle
  session[:member_count] = session[:members].count
  session[:results]      = randomizer(session[:teams], session[:members])
  erb :index, layout: :default
end

def randomizer(number_of_teams, members)
  teams = Array.new(number_of_teams) { Array.new }

  while members.count > 0
    teams.each { |team| team.push(members.pop) unless members.empty? }
  end

  teams.each_with_index.inject({}) do |result, (team, index)|
    result[index + 1] = team.join(', ')
    result
  end
end

