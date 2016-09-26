#!/usr/bin/env ruby
# encoding: utf-8

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # 七牛云配置 
      :provider  => 'qiniu',
      :qiniu_access_key  => ENV['QINIU_ACCESS_KEY'],
      :qiniu_secret_key  => ENV['QINIU_SECRET_KEY']
    }
    config.fog_directory  = ENV['QINIU_BUCKET'] 
  end
end
