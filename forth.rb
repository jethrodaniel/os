prompt = "? "
result_prompt = "=> "

puts "forth started. `q` to exit"

loop do
  print prompt
  line = gets.chomp

  # Exit on `q`.
  #
  # todo: rm this, replace with `(quit)`
  if line == "q"
    print "\n"
    exit
  end

  redo if line == ""

  print result_prompt
  puts line
end

puts "Done."
