require 'irb/completion'

# awesome print
begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError => err
  warn "Couldn't load awesome_print: #{err}"
end

IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:EVAL_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = '~/.irb-history'
IRB.conf[:USE_READLINE] = true

IRB.conf[:PROMPT][:CUSTOM] = {
  :AUTO_INDENT => true,
  :PROMPT_I => "› ",
  :PROMPT_S => "%l › ", :PROMPT_C => ".. ",
  :PROMPT_N => ".. ",
  :RETURN => "↝ %s\n"
}
IRB.conf[:PROMPT_MODE] = :CUSTOM

# Hirb
begin
  require 'hirb'
  HIRB_LOADED = true
rescue LoadError
  HIRB_LOADED = false
end

def enable_hirb
  if HIRB_LOADED
    Hirb::Formatter.dynamic_config['ActiveRecord::Base']
    Hirb.enable
  else
    puts "hirb is not loaded"
  end
end

def disable_hirb
  if HIRB_LOADED
    Hirb.disable
  else
    puts "hirb is not loaded"
  end
end

# https://samuelmullen.com/2010/04/irb-global-local-irbrc/
def load_irbrc(path)
  return if (path == ENV["HOME"]) || (path == '/')

  load_irbrc(File.dirname path)
  irbrc = File.join(path, ".irbrc")
  load irbrc if File.exist?(irbrc)
end

load_irbrc Dir.pwd
