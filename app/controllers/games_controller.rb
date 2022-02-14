require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { Array('A'..'Z').sample }
    @start_time = Time.now.to_i
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i
    @hash = { your_word: @word, time: (@end_time - @start_time), score: 0, message: '' }
    user = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    if user['found'] == false
      @hash[:message] = 'not an english word'
    elsif in_grid(@letters, @word)
      @hash[:message] = 'not in the grid'
    else
      @hash[:score] = user['length'] * 5 * 1 / @hash[:time]
      @hash[:message] = 'Well done!'
    end
    @hash
  end

  def in_grid(letters, word)
    result = []
    word = word.upcase.chars
    word.each do |letter|
      if letters.include?(letter)
        result << 'true'
        letters.delete_at(letters.find_index(letter))
      else
        result << 'false'
      end
    end
    result.include?('false')
  end
end
