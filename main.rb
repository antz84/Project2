# outside stuff we need
require 'sinatra'
# require 'sinatra/reloader'
require 'pg'

# local stuff we need
require_relative 'db_config'
require_relative 'models/item'
require_relative 'models/user'

# tracks if logged in or not
enable :sessions

# universal method helpers
helpers do
  # a function to check if anyone is there
  def logged_in?
    # finds the user id of the currently logged_in user
    if User.find_by(id: session[:user_id])
      # if there's a user logged in it will return something, thus true
      return true
    else
      # if there's no user logged in there won't be a value, hence false
      return false
    end
  end
  # who is there?
  def current_user
    User.find_by(id: session[:user_id])
  end
end

# route to index page
get '/' do
  erb :index
end

# route to create_account page
get '/create_account' do
  erb :create_account
end

# route to put some new user details into the db
post '/create_account' do
  user = User.new
  user.username = params[:name]
  user.password = params[:password]
  user.age = params[:age]
  user.location = params[:location]
  user.save
  redirect to '/login'
end

# route to login page
get '/login' do
  erb :login
end

# route to
get '/new' do
  if !logged_in?
    redirect to '/session/new'
  end
  erb :new
end

get '/session/new' do
  erb :login
end

# route to show all current users items
get '/wishlist' do
  # runs the function to check if anyone is there
  if logged_in?
    @item = Item.where(user_id: session[:user_id])
    erb :wishlist
  else
    redirect to '/'
  end
end

post '/wishlist' do
  if !logged_in?
    redirect to '/session/new'
  end
  item = Item.new
  item.name = params[:name]
  item.image_url = params[:image_url]
  item.save
  redirect to '/'
end

# login functionality
post '/session' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to '/'
  else
    erb :login
  end
end

get '/items/new' do
  if !logged_in?
    redirect to '/session/new'
  end
    erb :edit_wishlist
end

get '/users/:id' do
  @single_user = User.find(params[:id])
  erb :profile
end

get '/create_item' do
  erb :create_item
end

put '/create_item' do
  if !logged_in?
    redirect to '/'
  end

  item = Item.new
  item.name = params[:name]
  item.pic = params[:pic]
  item.price = params[:price]
  item.user_id = current_user.id
  item.save

  redirect to '/'
end

put '/wishlist' do
  erb :wishilst
end

delete '/session' do
  session[:user_id] = nil
  redirect to '/'
end

delete '/del/:id' do
  del = Item.find_by(id: params[:id])
  del.destroy
  redirect to '/wishlist'
end
