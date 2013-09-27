task :ping do
  open('http://sheffield-ultimate.herokuapp.com') { |io| puts "Pinged Heroku app. Status code: #{io.status[0]}" }
end
