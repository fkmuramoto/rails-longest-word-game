require 'open-uri'
require 'json'

class WordController < ApplicationController
  def game
    @start_time = Time.now
    @grid = ['A', 'M', 'E', 'T']
    # Array.new() { ('A'..'Z').to_a.sample }
  end

  def score
    @grid = JSON.parse(params[:grid])
    @guess = params[:guess]
    @time_taken = Time.now - Time.parse(params[:start_time])

    if included?
      if english?
        @score = @time_taken > 60.0 ? 0 : @guess.size * (1.0 - @time_taken / 60.0)
        @message = "Well done!"
      else
        @score = 0
        @message = "Not an english word!"
      end
    else
      @score = 0
      @message = "Not in the grid!"
    end
  end

# AUX

# included?
  def included?
      guess_upcase = @guess.upcase
      guess_upcase.chars.all? { |letter| guess_upcase.count(letter) <= @grid.count(letter) }
  end

# english?
  def english?
    response = open("https://wagon-dictionary.herokuapp.com/#{@guess}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
