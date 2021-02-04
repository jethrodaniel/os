require 'io/console'

prompt = "? "
result_prompt = "=> "

puts "[lisp] Started. `q` to exit"

print prompt

left_parent_count = 0
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

  # Skip spaces
  redo if char == 32 # ' '

  if char == 40 # (
    left_parent_count += 1
    got_left_paren = true
  end
  if char == 41 # )
    if left_parent_count == 0
      warn "\nunexpected `)`\n"
      print prompt
      redo
    end
    left_parent_count -= 1
  end

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

      # eval, print result
      print "op: #{operator}"

      # reset
      operator = ''
    end
    print "\n"
    print prompt
    redo
  end

  operator += char.chr
end

puts "[lisp] Exited."
