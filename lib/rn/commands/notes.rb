module RN
  module Commands
    module Notes
      PROMPT = TTY::Prompt.new
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def create(path, title)
          if !File.exist?(path + "/#{title}.rn")
            TTY::File.create_file "#{path}/#{title}.rn", PROMPT.multiline("Contenido de la nota: ")
          else
            PROMPT.error("Ya existe una nota con el mismo nombre en ese cuaderno")
          end
        end

        def call(title:, **options)
          book = options[:book]
          if title.match(/\A[a-z0-9]+\Z/i)
            if book != nil
              path=Dir.home + '/.my_rns' + '/' + book
              if !Dir.exist?(path)
                system("ruby bin/rn books create #{book}")
              end
            else
              path=Dir.home + '/.my_rns/cuaderno_global'
            end
            create(path, title)
          else
            PROMPT.error('Nombre de nota inválido')
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def delete(path)
          if File.exist?(path)
            File.delete(path)
          else
            PROMPT.error("No existe una nota con ese nombre en ese cuaderno")
          end
        end

        def call(title:, **options)
          book = options[:book]
          if book != nil
            if Dir.exist?(Dir.home + '/.my_rns'+'/'+ book)
              path=Dir.home + '/.my_rns' + '/' + book + "/#{title}.rn"
              delete(path)
            else
              PROMPT.error("No existe un cuaderno cuyo nombre sea #{book}")
            end
          else
            path=Dir.home + '/.my_rns/cuaderno_global' + "/#{title}.rn"
            delete(path)
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content of a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def update(path, title)
          editor = TTY::Editor.new(prompt: "¿Qué editor querés usar?")
          if File.exist?(path + "/#{title}.rn")
            editor.open("#{path}/#{title}.rn")
          else
            PROMPT.error("No existe una nota #{title} en ese cuaderno")
          end
        end

        def call(title:, **options)
          book = options[:book]
          if book != nil
            path=Dir.home + "/.my_rns/#{book}"
            if Dir.exist?(path)
              update(path,title)
            else
              PROMPT.error("No existe el cuaderno #{book}")
            end
          else
            path=Dir.home + '/.my_rns/cuaderno_global'
            update(path,title)
          end
          
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def rename(path, old_name, new_name)
          if File.exist?("#{path}/#{old_name}.rn")          
            File.rename("#{path}/#{old_name}.rn", "#{path}/#{new_name}.rn")
          else
            PROMPT.error("No existe una nota cuyo nombre sea: #{old_name}")
          end
        end

        def call(old_title:, new_title:, **options)
          book = options[:book]
          if new_title.match(/\A[a-z0-9\s]+\Z/i)
            if book != nil
              if Dir.exist?(Dir.home + "/.my_rns/#{book}")
                path = Dir.home + "/.my_rns/#{book}"
                rename(path, old_title, new_title)
              else
                PROMPT.error("No existe el cuaderno #{book}")
              end
            else
              path=Dir.home + "/.my_rns/cuaderno_global"
              rename(path, old_title, new_title)
            end
          else
            PROMPT.error("Nombre de archivo inválido")
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          if global
            Dir.chdir(Dir.home + "/.my_rns/cuaderno_global")
            cuaderno = Dir.glob('*').select {|f| File.file? f}
            cuaderno.each {|note| p note, :rainbow}
          elsif book != nil
            if Dir.exist?(Dir.home + "/.my_rns/#{book}")
              Dir.chdir(Dir.home + "/.my_rns/#{book}")
              cuaderno = Dir.glob('*').select {|f| File.file? f}
              cuaderno.each {|note| p note, :rainbow}
            else
              PROMPT.error ("No existe un cuaderno con el nombre #{book}")
            end
          else
            Dir.chdir(Dir.home + "/.my_rns")
            files=Dir['**/*'].reject {|fn| File.directory?(fn)}
            files.each {|file| p file, :rainbow}
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def show(path, title)
          if File.exist?(path + "/#{title}.rn")
            p title, :yellow
            File.foreach("#{path}/#{title}.rn") do |line|
              puts line
            end
          else
            PROMPT.error("No existe una nota #{title} en ese cuaderno")
          end
        end

        def call(title:, **options)
          book = options[:book]
          if book != nil
            path=Dir.home + "/.my_rns/#{book}"
            if Dir.exist?(path)
              show(path,title)
            else
              PROMPT.error("No existe el cuaderno #{book}")
            end
          else
            path=Dir.home + '/.my_rns/cuaderno_global'
            show(path,title)
          end
        end
      end
    end
  end
end
