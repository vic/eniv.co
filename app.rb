require 'sinatra'
require 'open-uri'

get '/v/:id.mp4' do
  send_file File.expand_path("#{params[:id]}-backward.mp4")
end

get '/v/:id' do
  id = params[:id]
  url = "http://vine.co/v/#{id}"
  html = open(url).read
  video_url = html.match(/(https?:\/\/.*\.mp4)\?/)[1]
  puts "curl -L #{video_url} -o #{id}.mp4"
  `curl -L #{video_url} -o #{id}.mp4`
  `bash reverse.sh #{id}.mp4 #{id}-backward.mp4`
  subed = html.gsub(video_url, "http://localhost:4567/v/#{id}.mp4")
  subed
end

