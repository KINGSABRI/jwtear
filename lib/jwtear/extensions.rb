module JWTear
  module Utils

    module CoreExtensions
      module String
        def bold; colorize(self, "\e[1m"); end
        def red; colorize(self, "\e[1m\e[31m"); end
        def green; colorize(self, "\e[1m\e[32m"); end
        def dark_green; colorize(self, "\e[32m"); end
        def reset; colorize(self, "\e[0m\e[28m"); end
        def underline; colorize(self, "\e[4m"); end
        def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
        def mv_down(n=1) cursor(self, "\033[#{n}B") end
        def cls_upline; cursor(self, "\e[K") end
        def cursor(text, position)"\r#{position}#{text}" end
      end
    end
    # class String
    #   def bold; colorize(self, "\e[1m"); end
    #   def red; colorize(self, "\e[1m\e[31m"); end
    #   def green; colorize(self, "\e[1m\e[32m"); end
    #   def dark_green; colorize(self, "\e[32m"); end
    #   def reset; colorize(self, "\e[0m\e[28m"); end
    #   def underline; colorize(self, "\e[4m"); end
    #   def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
    #   def mv_down(n=1) cursor(self, "\033[#{n}B") end
    #   def cls_upline; cursor(self, "\e[K") end
    #   def cursor(text, position)"\r#{position}#{text}" end
    # end

  end
end