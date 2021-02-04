require 'io/console'

prompt = "> "

puts "[lisp] Started. `q` to exit"

print prompt

loop do
  c = $stdin.noecho(&:getch).ord

  if c == 113 # 'q'
    print "\n"
    exit
  end

  print c.chr
  # print c

  # TODO: continue to next line if unclosed parens
  if c == 13 # "\r"
    print prompt
    print "\n"
    print prompt
    redo
  end


end

puts "[lisp] Exited."
