def cajon_de_notas()
    if ! Dir.exist?(Dir.home + '/.my_rns')
        Dir.mkdir(File.join(Dir.home, ".my_rns"), 0700)
    end
end        
