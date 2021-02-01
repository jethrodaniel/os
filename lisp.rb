require 'io/console'

prompt = "> "

puts "[lisp] Started. `q` to exit"

print prompt

loop do
  c = $stdin.noecho(&:getch)

  exit if c == 'q'

  print c

  if c == "\r"
    print prompt
    print "\n"
    break
  end
end

puts "[lisp] Exited."
