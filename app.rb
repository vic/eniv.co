require 'sinatra'
require 'open-uri'

set :port, 80
set :root, File.dirname(__FILE__)
set :public_folder, "#{settings.root}/public"
set :forwards, "#{settings.public_folder}/forwards"
set :backwards, "#{settings.public_folder}/backwards"

get '/' do
  'go to /v/yourVineId'
end

get '/v/:id.mp4' do
  send_file File.join(settings.backwards,"#{params[:id]}.mp4")
end

get '/v/:id' do |id|
  url = "http://vine.co/v/#{id}"
  html = open(url).read
  video_url = html.match(/(https?:\/\/.*\.mp4)\?/)[1]
  unless File.file?("#{settings.backwards}/#{id}.mp4")
    # puts "curl -L #{video_url} -o #{settings.forwards}/#{id}.mp4"
    `curl -L #{video_url} -o #{settings.forwards}/#{id}.mp4`
    `bash reverse.sh #{settings.forwards}/#{id}.mp4 #{settings.backwards}/#{id}.mp4`
  end
  subed = html.gsub(video_url, "/v/#{id}.mp4")
  subed
end
