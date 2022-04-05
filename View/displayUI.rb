def display_title(text)
    font = TTY::Font.new(:doom)
    puts Rainbow(font.write(text, letter_spacing: 2)).springgreen
end

def display_error(text)
    puts Rainbow(text).white.bg(:yellow)
end

def highlight(text)
    return Rainbow(text).black.bg(:white)
end

def goodbye_message()
    puts Rainbow("\nYou quit the APP. Thank You for using it! “ヽ(^ ▽ ^)ノ” ").black.bg(:springgreen)
end

def green_text(text)
    return Rainbow(text).springgreen
end