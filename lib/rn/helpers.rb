def message(dict)
    if dict['type'] == 'ok'
        TTY::Prompt.new.ok(dict['message'])
    else
        TTY::Prompt.new.error(dict['message'])
    end
end
    
def cajon_de_notas()
    if ! Dir.exist?(Dir.home + '/.my_rns')
        Dir.mkdir(File.join(Dir.home, ".my_rns"), 0700)
    end
end