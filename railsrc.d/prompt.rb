def setup_rails_irb_prompt
  dangerous_envs = %w(production smoke)
  rails_env = ENV['RAILS_ENV']
  rails_env = rails_env.upcase if dangerous_envs.include?(rails_env)

  prompt = defined?(DETECTED_RAILS_ROOT) ? File.basename(DETECTED_RAILS_ROOT) : 'rails'
  setup_custom_irb_prompt(prompt + " #{rails_env}")
end

setup_rails_irb_prompt