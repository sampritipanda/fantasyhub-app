require 'sinatra'
#require_relative '../fantasyhub/lib/fantasyhub'
require 'fantasyhub'
require 'debugger'

get '/' do
  @scores = []
  av_users.each do |uid|
    @scores << [uid, calculate_score(uid)]
  end
  erb :index
end

get '/:uid' do
  @uid = params[:uid]
  @score = calculate_score(@uid)
  erb :show
end

require 'json'
require 'open-uri'

def av_users
  JSON.parse(open("https://api.github.com/orgs/AgileVentures/members").read).map{|a| a["login"]}
end

def calculate_score(user)
  Fantasyhub.score_activity_feed(user).map(&:score).reduce(:+)
end
