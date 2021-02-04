require 'io/console'

prompt = "? "
result_prompt = "=> "

puts "[lisp] Started. `q` to exit"

print prompt

got_left_paren = false
got_right_paren = false
read_char = false
operator = ''
operands = []

loop do
  # Get one character at a time
  char = $stdin.noecho(&:getch).ord

  # Echo character when typed
  print char.chr

  # Exit on `q`.
  #
  # todo: rm this, replace with `(quit)`
  if char == 113 # q
    print "\n"
    exit
  end

  # Evaluate input on newline.
  #
  # TODO: continue to next line if unclosed parens
  if char == 13 # \r
    if operator == ''
      print prompt
    else
      print result_prompt
      print "op: #{operator}"
    end
    print "\n"
    print prompt
    redo
  end

  operator += char.chr
end

puts "[lisp] Exited."
