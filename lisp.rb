require 'io/console'

prompt = "> "

puts "[lisp] Started. `q` to exit"

print prompt

loop do
  c = $stdin.noecho(&:getch).ord

  exit if c == 113 # 'q'

  print c.chr
  # print c

  if c == 13 # "\r"
    print prompt
    print "\n"
    break
  end
end

puts "[lisp] Exited."
