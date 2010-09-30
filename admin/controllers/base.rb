# encoding:utf-8
require 'json'
Admin.controllers :base do

  get :index, :map => "/" do
    render "base/index"
  end

  get :index, :map => "/base" do
    render "base/index"
  end

  get :tag_list_json, :map => "/tags.json" do
    content_type 'application/json'
    Tag.all.to_a.collect {|t| t.name }.to_json
  end
end
