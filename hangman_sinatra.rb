require 'sinatra'
require 'sinatra/reloader'



$attempts = 6
words = ["kafa", "mleko", "piksla", "flasa", "papir", "zec"]
@@word_to_guess =  words[rand(words.length)].split('')
@@guessed_letters = Array.new(@@word_to_guess.length, "___".to_s)
@@wrong_guesses = []
$color = "black"
@@response = ""


def track_guess(guess)
  if guess.is_a?(String)
    guess.downcase!
    if @@wrong_guesses.include?(guess)
    @@response = "You tried that. Try something new:"
      return
    end
    if @@guessed_letters.include?(guess)
    @@response == "You already tried that one, it did work, but no reason to brag. Try something new:"
      return
    end
    if @@word_to_guess.include?(guess)
      @@response = "Nice guess! Keep going:"
      @@guessed_letters.each_with_index do |letter,index|
      if @@word_to_guess[index] == guess
        @@guessed_letters[index] = guess
        return
      end
      end
      else
        $attempts == $attempts - 1
        @@wrong_guesses.push(guess)
        @@response = "Wrong guess, one less attempt, one step closer to hanging. Try again"
      return
    end

  elsif
    @@response = "Wrong input, try a letter this time"
end
end


def modify_image
  if $attempts == 6
    return "images/first.png"
  elsif $attempts == 5
    return "images/second.png"
  elsif $attempts == 4
    return "images/third.png"
  elsif $attempts == 3
    return "images/fourth.png"
  elsif $attempts == 2
    return "images/fifth.png"
  elsif $attempts == 1
    return "images/sixth.png"
  elsif $attempts == 0
    return "images/seventh.png"
  end
end

def win_loss
  if !@@guessed_letters.include?("___")
    @@response = "You won!"
    $color = "blue"
  end
  if @@guessed_letters.include?("___") && $attempts == 0
    @@response = "You lost"
    $color = "red"
  end
end

get '/' do

  guess = params['guess']
  track_guess(guess)

  $attempts = 6 - @@wrong_guesses.length
  image = modify_image
  win_loss
  erb :index, :locals => {:guessed_letters => @@guessed_letters, :attempts => $attempts, :response => @@response, :wrong_guesses => @@wrong_guesses, :image => image, :color => $color}
end

