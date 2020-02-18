require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    (1..10).to_a.each do
      @letters << ('A'..'Z').to_a.sample
    end
    return @letters
  end

  #refactored and guaranteed to have vowels.
  #(['a','e','i','o','u'] + Array.new(5){('a'..'z').to_a.sample}).shuffle

  def score
    @results = {}
    if JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read)['found']
      grid_hash = Hash.new(0)
      params[:letters].split(" ").each { |a| grid_hash[a.downcase] += 1 }
      params[:word].chars.each { |a| grid_hash[a.to_s.downcase] -= 1 }
      if grid_hash.values.all? { |v| v >= 0 }
        @results[:message] = "Well done"
      elsif grid_hash.values.all? { |v| v < 0 }
        @results[:message] = "Not in the grid!"
      end
    else
      @results [:message] = 'Not an english word!'
    end
  end
end
