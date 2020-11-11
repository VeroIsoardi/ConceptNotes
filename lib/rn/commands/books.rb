module RN
  module Commands
    module Books
      PROMPT = TTY::Prompt.new
      
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          if name.match(/\A[a-z0-9\s]+\Z/i)
            if ! Dir.exist?(Dir.home + "/.my_rns/#{name}")
              Dir.mkdir(File.join(Dir.home, ".my_rns/#{name}"), 0700)
            else
              PROMPT.error('Ya existe un cuaderno con ese nombre')  
            end
          else 
            PROMPT.error('Nombre de archivo inválido')
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if global
            path = Dir.home + "/.my_rns/cuaderno_global"
            Dir.foreach(path) do |file|
              if ((file.to_s != ".") and (file.to_s != ".."))
                File.delete("#{path}/#{file}")
              end
            end
          else
            if Dir.exist?(Dir.home + "/.my_rns/#{name}")          
              FileUtils.remove_dir(Dir.home + "/.my_rns/#{name}")
            else
              PROMPT.error("No existe un cuaderno cuyo nombre sea: #{name}")
            end
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          Dir.chdir(Dir.home + "/.my_rns/")
          cuaderno = Dir.glob('*').select {|f| File.directory? f}
          cuaderno.each {|book| p "> #{book}", :rainbow}
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          if new_name.match(/\A[a-z0-9\s]+\Z/i)
            if Dir.exist?(Dir.home + "/.my_rns/#{old_name}")          
              File.rename(Dir.home+"/.my_rns/#{old_name}", Dir.home + "/.my_rns/#{new_name}")
            else
              PROMPT.error("No existe un cuaderno cuyo nombre sea: #{old_name}")
            end
          else
            PROMPT.error("Nombre de archivo inválido")
          end
        end
      end
    end
  end
end
