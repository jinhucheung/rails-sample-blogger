#!/usr/bin/env ruby
# encoding: utf-8

if Rails.env.production?
  CarrierWave.configure do |config|
   # 七牛云配置 
   config.storage             = :qiniu
   config.qiniu_access_key    = ENV['QINIU_ACCESS_KEY']
   config.qiniu_secret_key    = ENV['QINIU_SECRET_KEY']
   config.qiniu_bucket        = "hwblog"
   config.qiniu_bucket_domain = "oe4x8fz0j.bkt.clouddn.com"
   config.qiniu_bucket_private= true #default is false
   config.qiniu_block_size    = 4*1024*102
   config.qiniu_protocol      = "http"
   config.qiniu_up_host       = 'http://up.qiniug.com'
  end
end
