#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'json'
require_relative '../lib/house.rb'
require_relative '../lib/web.rb'
require_relative '../lib/json.rb'

def show(house)
  puts "adds >> category : #{house.category}
  ** address : #{house.address}
  ** price : #{house.price} Ariary
  ** date : #{house.date}
  ** link : #{house.link}"
  puts '===================================================================='
end

def warning(house, old)
  puts "Warning: #{house[:category]} => The price has changed.
  \n Old price: #{old['price']} Ariary \t => New price #{house[:price]} Ariary"
end

class Main
  extend Web
  extend Json
  houses = []
  list_houses = get_page.css('div.post')
  par_page = list_houses.count
  page = 1
  total = get_page.css('ul.tabset li:first-child a').text.tr('()', '').split(' ').last.to_i
  last_page = (total / par_page).to_f.round
  while page <= 2
    list_houses = get_page(url_setting(page)).css('div.post')

    puts "Page #{page}"
    puts url_setting(page)
    list_houses.each do |house_listing|
      house = House.new(house_listing)
      houses << house.house_hash
      show(house)
    end
    page += 1
  end

  check(houses)
end
