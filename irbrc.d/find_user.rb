def find_user(term)
  @user_find_model ||=
    eval(
      %w(Character User Person).detect do |name|
        begin
          eval(name)
        rescue
        end
      end
    )

  @user_find_method ||=
    %w(login name).detect do |name|
      @user_find_model.column_names.include?(name)
    end
    
  @user_find_model.send("find_by_#{@user_find_method}", term)

end