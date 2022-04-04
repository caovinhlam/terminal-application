def display_title(text)
    font = TTY::Font.new(:doom)
    puts font.write(text, letter_spacing: 2)
end
