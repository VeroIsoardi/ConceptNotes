module RN
    class Note
        attr_accessor :title, :content, :book
        
        def create_note(path, title, book)
            if !File.exist?(path + "/#{title}.rn")
                editor = TTY::Editor.new(prompt: "¿Qué editor querés usar?")
                editor.open("#{path}/#{title}.rn")
                message = {"message"=>"La nota #{title} se creó con éxito!", "type"=>"ok"}
            else
                message = {"message"=>"Ya existe una nota #{title} con el mismo nombre en el cuaderno #{book}", "type"=>"error"}
            end
            return message
        end

        def create(title, book)
            path = Dir.home + '/.my_rns'
            if book != nil
                path = path + '/' + book
            end
            if !Dir.exist?(path)
                Book.new.create(book)
            end
            self.create_note(path, title, book)      
        end

        def delete_note(path, title, book)
            if File.exist?(path)
                File.delete(path)
                message = {"message"=>"La nota #{title} se eliminó con éxito!", "type"=>"ok"}
            else
                message = {"message"=>"No existe una nota #{title} en el cuaderno #{book}", "type"=>"error"}
            end
        end

        def delete(title, book)
            path=Dir.home + '/.my_rns'
            if book != "global"
                if Dir.exist?(Dir.home + '/.my_rns/' + book)
                    path= path + '/' + book + "/#{title}.rn"
                    message = delete_note(path, title, book)
                else
                    message = {"message"=>"No existe el cuaderno #{book}", "type"=>"error"}
                end
            else
                path= path + "/#{title}.rn"
                message = delete_note(path, title, book)
            end
            return message
        end

        def edit_note(path, title, book)
            editor = TTY::Editor.new(prompt: "¿Qué editor querés usar?")
            if File.exist?(path + "/#{title}.rn")
                editor.open("#{path}/#{title}.rn")
                message={"message"=>"La nota #{title} se actualizó con éxito!", "type"=>"ok"}
            else
                message={"message"=>"No existe una nota #{title} en el cuaderno #{book}", "type"=>"error"}
            end
            
        end

        def edit(title, book)
            path = Dir.home + '/.my_rns'
            if book != nil
                path = path + '/' + book
            end
            if Dir.exist?(path)
                message = self.edit_note(path, title, book)       
            else
                message = {"message"=>"No existe el cuaderno #{book}", "type"=>"error"}
            end
            return message
        end

        def rename_note(path, old_name, new_name)
            if File.exist?("#{path}/#{old_name}.rn") & !File.exist?("#{path}/#{new_name}.rn")
                File.rename("#{path}/#{old_name}.rn", "#{path}/#{new_name}.rn")
                message = {"message"=>"Se renombró a la nota #{old_name} por #{new_name} con éxito!", "type"=>"ok"}
            else
                message = {"message"=>"No se pudo renombrar la nota, o porque no existe una nota de nombre #{old_name}, 
                o porque ya existe una nota llamada #{new_name}", "type"=>"error"}
            end
            return message
        end

        def rename(old_name, new_name, book)
            path=Dir.home + "/.my_rns"
            if book != nil
                if Dir.exist?(path + '/' + book)
                    path = path + '/' + book
                    message = rename_note(path, old_name, new_name)
                else
                    message = {"message"=>"No existe el cuaderno #{book}", "type"=>"error"}
                end
            else
                message = rename_note(path, old_name, new_name)
            end     
        end

        def list(book, global)
            path = Dir.home + "/.my_rns"
            Dir.chdir(path)
            if book != nil
                if Dir.exist?(path + '/' + book)
                    Dir.chdir(path + '/' + book)
                    cuaderno = Dir.glob('*').select {|f| File.file? f}
                    cuaderno.each {|note| p note, :rainbow}
                else
                    TTY::Prompt.new.error("No existe un cuaderno #{book}")
                end
            elsif global
                cuaderno = Dir.glob('*').select {|f| File.file? f}
                cuaderno.each {|note| p note, :rainbow}           
            else
                files=Dir['**/*'].reject {|fn| File.directory?(fn)}
                files.each {|file| p file, :rainbow}
            end
        end

        def show_note(path, title, book)
            if File.exist?("#{path}/#{title}.rn")
                p title, :yellow
                File.foreach("#{path}/#{title}.rn") do |line|
                    puts line
                end
            else
                return message = {"message"=>"No existe la nota #{title} en el cuaderno #{book}", "type"=>"error"}
            end
        end

        def show(title, book)
            path = Dir.home + "/.my_rns"
            if book != nil
                path = path + '/' + book
                if Dir.exist?(path)
                    message = show_note(path,title, book)
                else
                    message = {"message"=>"No existe el cuaderno #{book}", "type"=>"error"}
                end
            else
                message = show_note(path,title, "global")
            end
            return message
        end

        def plain_text_to_HTML(path)
            data=""
            File.foreach(path) do |line|
                data << CommonMarker.render_html(line, :DEFAULT, [:table, :tasklist, :strikethrough, :autolink, :tagfilter])        
            end
            File.write(path[0..-3]  + 'html', data)
        end

        def export_all()
            filename = File.join("**", "*.rn")
            Dir.glob(filename).each do|f|
                if File.file? f 
                    plain_text_to_HTML(f)
                end
            end
        end

        def export_book(path)
            Dir.chdir(path)
            cuaderno = Dir.glob('*.rn').select {|f| File.file? f}
            cuaderno.each {|note| plain_text_to_HTML(note)}
        end

        def export(title, book)
            path = Dir.home + "/.my_rns"
            Dir.chdir(path)
            if book != nil
                if book == "global"
                    export_book(path)
                    message={"message"=>"La notas se exportaron con éxito!", "type"=> "ok"}
                elsif Dir.exist?(Dir.home + "/.my_rns/"+ book)
                    path+="/#{book}"
                    if title != nil
                        if File.exist?("#{path}/#{title}.rn")
                            plain_text_to_HTML("#{path}/#{title}.rn")
                            message={"message"=>"La nota #{title} en el cuaderno #{book}, se exportó con éxito!", "type"=> "ok"}
                        else
                            message={"message"=>"No existe la nota #{title} en el cuaderno #{book}", "type"=> "error"}
                        end
                    else
                        export_book(path)
                        message={"message"=>"Las notas del cuaderno #{book}, se exportaron con éxito!", "type"=> "ok"}
                    end
                else
                    message={"message"=>"No existe el cuaderno #{book}", "type"=> "error"}
                end
            else
                if title != nil
                    if File.exist?("#{path}/#{title}.rn")
                        plain_text_to_HTML("#{path}/#{title}.rn")
                        message={"message"=>"La nota #{title} se exportó con éxito!", "type"=> "ok"}
                    else
                        message={"message"=>"No existe la nota #{title} en el cuaderno global", "type"=> "error"}
                    end
                else
                    export_all()
                    message={"message"=>"Todas las notas se exportaron con éxito!", "type"=> "ok"}
                end
            end
            return message
        end
    end
end