class Mastermind
  COLORS = ["Pink", "Red", "Green", "Yellow", "Blue",
            "White"].freeze
  ANSI_COLORS = {
    "Pink" => "\e[35m",
    "Red" => "\e[31m",
    "Green" => "\e[32m",
    "Yellow" => "\e[33m",
    "Blue" => "\e[36m",
    "White" => "\e[37m"
  }.freeze
  CODE_LENGTH = 4
  MAX_TURNS = 12

  def initialize
    @code = generate_code
    @colored_code = @code.map { |color| display_color(color) }
    @turns = 0
  end

  # Method to get the ANSI color code
  def color_code(color_name)
    ANSI_COLORS[color_name] || color_name # Returns the ANSI code or the original color name if not found
  end

  # Method to display a color with its ANSI code
  def display_color(color_name)
    "#{color_code(color_name)}#{color_name}\e[0m" # Resets the color after displaying
  end

  def display_turn
    puts "Current Turn: #{@turns + 1} of #{MAX_TURNS}"
  end

  def play
    until @turns >= MAX_TURNS
      display_turn
      guess = prompt_guess
      @turns += 1
      if guess == @code
        puts "Congratulations! You've cracked the code!"
        return
      else
        provide_feedback(guess)
      end
    end

    puts "Game over! The secret code was: #{@colored_code.join(" ")}"
  end

  private

  def generate_code
    Array.new(CODE_LENGTH) { COLORS.sample }
  end

  def prompt_guess
    loop do
      puts "Enter your guess (available colors: #{COLORS.map { |color| display_color(color) }.join(", ")}):"
      guess = gets.chomp.split.map(&:capitalize)
      return guess if valid_guess?(guess)

      puts "Invalid guess. Make sure to choose #{CODE_LENGTH} colors from the list."
    end
  end

  def valid_guess?(guess)
    guess.length == CODE_LENGTH && guess.all? { |color| COLORS.include?(color) }
  end

  def provide_feedback(guess)
    feedback = []
    temp_code = @code.clone

    guess.each_with_index do |color, index|
      if color == temp_code[index]
        feedback << "Black"
        temp_code[index] = nil
      end
    end

    guess.each_with_index do |color, index|
      if temp_code.include?(color) && color != temp_code[index]
        feedback << "White"
        temp_code[temp_code.find_index(color)] = nil
      end
    end

    puts "Feedback: #{feedback.join(", ")}"
  end
end

mastermind = Mastermind.new

mastermind.play
