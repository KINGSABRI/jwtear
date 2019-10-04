module JWTear
  module Helpers
    module Extensions
      # Add print styles
      module Print
        def print_status(msg);  puts "[*] ".blue   + "#{msg}"; end
        def print_good(msg);    puts "[+] ".green  + "#{msg}"; end
        def print_error(msg);   puts "[x] ".red    + "#{msg}"; end
        def print_bad(msg);     puts "[!] ".red    + "#{msg}"; end
        def print_warning(msg); puts "[!] ".yellow + "#{msg}"; end
        def print_h1(msg);  puts  "-[" + "#{msg}".green.bold + "]----"; end
        def print_h2(msg);  puts  "[+] ".green + "#{msg}:" ; end
        def print_h3(*msg); print " - ".cyan.bold + "#{msg[0]}:" " #{msg[1..-1].join(' ')}\n" ; end
      end
    end
  end
end
