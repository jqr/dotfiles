# From http://github.com/ryanb/dotfiles/tree/master/irbrc

# list methods which aren't in superclass
def local_methods(obj = self)
  (obj.methods - obj.class.superclass.instance_methods).sort
end
