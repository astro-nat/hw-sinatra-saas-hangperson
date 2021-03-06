class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word



  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def update_guess_lists(str)
    if @word.include?(str) then
        @guesses += str
      else  
        @wrong_guesses += str
    end
  end
  
  def previous_guess?(str)
    return (@wrong_guesses.include?(str) or @guesses.include?(str))
  end

  def valid_guess?(str)
    return (!str.nil? and str.length == 1 and !str.match(/[^A-Za-z]/))
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(guess_str)
    if !valid_guess?(guess_str) then
      raise ArgumentError.new("Invalid guess")
    end

    guess_str = guess_str.downcase
    valid_guess = false
    if !previous_guess?(guess_str) then
      update_guess_lists(guess_str)
      valid_guess = true
    end

     return valid_guess
  end

  def check_win_or_lose
    if word_with_guesses == @word then
      return :win
    elsif @wrong_guesses.length >= 7 then
      return :lose
    else
      return :play
    end
  end

   def word_with_guesses
    w = ("-"*@word.length)
    for i in 0..@word.length-1 do
      if @guesses.include?(@word[i]) then
        w[i] = @word[i]
      end
    end
    return w
  end

end
