require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/json"
require 'sinatra/param'
require 'json'

set :database, "mysql2://admin:1234@localhost:3306/m5"

class User < ActiveRecord::Base
end

class App < Sinatra::Base
  helpers Sinatra::Param
  
  set :show_exceptions, false

  before do
    content_type :json
  end

  get '/' do
    p 'Hello!'
  end

  get '/users/?' do
    @users = User.all
    @users.to_json
  end
  
  post '/user' do
    param :name,           String, required: true
    param :email,           String, required: true
    @users = User.new(name: params['name'], email: params['email'])
    @users.save

    json :success => true
  end

  delete '/user' do 
    param :id,           String, required: true
    begin
      @message = "id no existente" # en caso de error 
      
      User.find(params['id']).destroy
      json :success => true
    end
  end

  put '/user' do
    param :id,           String, required: true
    param :name,           String, required: true
    param :email,           String, required: true

    @users = User.find_by_id(params['id'])
    @users.name = params['name']
    @users.email = params['email']
    @users.save

    json :success => true
  end

  get '/users/:id/?' do
    @user = User.find_by_id(params[:id])
    @user.to_json
  end

  error do
    json :success => false, :message => @message
  end
end

