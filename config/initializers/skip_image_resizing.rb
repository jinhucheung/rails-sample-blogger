#!/usr/bin/env ruby
# encoding: utf-8

if Rails.env.test?
  CarrierWave.configure do | config |
    config.enable_processing = false
  end
end
