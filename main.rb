require 'sinatra'
require 'shotgun'
require 'active_support/all'
require 'pg'

get '/test' do
	"by query string: " + params[:grizmo]
end

get '/test/:grizmo' do
	"in the url path: " + params[:grizmo]
end

post '/test' do
	"by post (in the headers): " + params[:grizmo]
end

# index -- list all dogs
get '/' do
	sql = "select * from dogs order by breed, name;"
	@dogs = run_sql(sql)
	erb :list
end

# new -- show a form to add a new dog
get '/new' do
	erb :form
end

# create -- create the new dog in the db
post '/create' do
	sql = "insert into dogs (name, breed, image) values " +
	"('#{params[:name]}', '#{params[:breed]}', '#{params[:image]}');"
	
	run_sql(sql)
	
	redirect '/'
end

# edit -- show a form to edit a dog's information
get '/:id/edit' do
	erb :form
end

# update -- update the specific dog in the db
post '/:id/update' do
	redirect '/'
end

# show -- show a specific dog's information
get '/:id' do
	erb :show
end

# delete -- delete a specific dog in the db
delete '/:id' do
	redirect '/'
end

private

def run_sql(sql)
	conn = PG.connect( :dbname => 'doggies', :host => 'localhost' )
	result = conn.exec(sql)
	conn.close
	result
end
