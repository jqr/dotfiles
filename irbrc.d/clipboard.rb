case RUBY_PLATFORM
when /darwin/ 
  def copy(str)
    IO.popen('pbcopy', 'w') { |f| f << str.to_s }
    str.to_s # return what we actually copied
  end

  def paste
    `pbpaste`
  end

when /linux/
  def copy(str)
    IO.popen('xclip -i', 'w') { |f| f << str.to_s }
  end

  def paste
    `xclip -o`
  end
end

def eval_paste
  eval(paste)
end

