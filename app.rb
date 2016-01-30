require 'sinatra'

get "/" do
  erb :index, layout: :default
end

post "/" do
  @teams   = params["teams"].to_i
  @members = params["members"].scan(/[0-9A-Za-z]+/).shuffle
  @count   = @members.count
  @results = randomizer(@teams, @members)
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

