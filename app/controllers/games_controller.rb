require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @message = message
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def message
    letters = params[:letters].split
    word = params[:word].upcase
    if included?(word, letters)
      if english_word?(word)
        "Congrats! #{word} is a valid English word!"
      else
        "Sorry but #{word} doesn't seem to be an english word.."
      end
    else
      "Sorry but #{word} can't be built out of #{letters.join(', ').upcase}"
    end
  end
end
