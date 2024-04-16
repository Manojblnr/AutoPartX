
# This is for routes and it will execute the models funtions
# routes.rb 

begin
	require_relative '../../.env.rb'
rescue LoadError => e
	puts e.message
end

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

%w(
    defaults
    models
).each { |lib| require_relative lib }

class App < Roda
    plugin :render
    plugin :json

    route do |r|
        body = request.body.read
		request.body.rewind
		data = JSON.parse(body) rescue {} 
        data = indifferent_data(data)

        r.root do
            puts 'server is running in root'
        end

        r.on "test" do
            puts 'test successfull'
        end
    end
end