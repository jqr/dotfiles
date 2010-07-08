def setup_custom_irb_prompt(name)
  green = "\e[32m"
  red = "\e[31m"
  clear = "\e[0m"
  
  IRB.conf[:PROMPT][:CUSTOM] = {
    # Flag  Description
    # %N    Current command.
    # %m    to_s of the main object (self).
    # %M    inspect of the main object (self).
    # %l    Delimiter type. In strings that are continued across a line break, %l will display the type of delimiter used to begin the string, so you'll know how to end it. The delimiter will be one of ", ', /, ], or `.
    # %ni   Indent level. The optional number n is used as a width specification to printf, as printf("%nd").
    # %nn   Current line number (n used as with the indent level).
    # %%    A literal percent sign.

    :PROMPT_I => "#{name}> ",                                      # standard prompt
    :PROMPT_C => "#{' ' * name.size}> ",           # multi-line statment prompt
    :PROMPT_S => "#{' ' * (name.size - 1)}%l> ",   # multi-line string prompt

    :RETURN => "#{red}#{' ' * (name.size - 1)}=> %s#{clear}\n",  # return value formatting, see table below
  }
  IRB.conf[:PROMPT_MODE] = :CUSTOM
end

setup_custom_irb_prompt('irb')