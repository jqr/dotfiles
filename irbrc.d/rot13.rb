# Stole from David Jones (unixmonkey)
class String
  def rot13
    tr('A-Za-z', 'N-ZA-Mn-za-m')
  end
end
