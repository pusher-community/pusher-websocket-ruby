ENV["WATCHR"] = "1"
system 'clear'
puts "Watchr: Ready! :-)"

def notify_send(result)
  #title = "Watchr Test Results"
  if result.include?("FAILED") or result.include?("ERROR")
    title = "FAIL"
    image = "~/.autotest_images/fail.png" 
    message = "One or more tests have failed"
  else
    title = "PASS"
    image = "~/.autotest_images/pass.png"
    message = "All tests pass"
  end

  options = "-c Watchr --icon '#{File.expand_path(image)}' '#{title}' '#{message}' --urgency=critical"
  system %(notify-send #{options} &)
end

def run(cmd)
  puts(cmd)
  `#{cmd}`
end

def run_all_tests
  system('clear')
  result = run "bacon test/*_test.rb"
  notify_send result
  puts result
end

def run_suite
  run_all_tests
end

watch('test/teststrap\.rb') { run_all_tests }
watch('test/factories\.rb') { run_all_tests }
watch('test/.*_test.*\.rb') { run_all_tests }
watch('lib/*\.rb') { run_all_tests }
watch('lib/.*/*\.rb') { run_all_tests }

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
