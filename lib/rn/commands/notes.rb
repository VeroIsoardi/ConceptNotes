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

        def call(title:, **options)
          book = options[:book]
          if title.match(/\A[a-z0-9]+\Z/i)
            status = Note.new.create(title, book)
          else
            status = {"message"=>"Nombre de nota inválido", "type"=>"error"}  
          end
          if status['type'] == 'ok'
            PROMPT.ok(status['message'])
          else
            PROMPT.error(status['message'])
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

        def call(title:, **options)
          book = options[:book]
          if book == nil
            book = "global"
          end
          status = Note.new.delete(title, book)
          if status['type'] == 'ok'
            PROMPT.ok(status['message'])
          else
            PROMPT.error(status['message'])
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
        def call(title:, **options)
          book = options[:book]
          status = Note.new.edit(title, book)
          if status['type'] == 'ok'
            PROMPT.ok(status['message'])
          else
            PROMPT.error(status['message'])
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

        def call(old_title:, new_title:, **options)
          book = options[:book]
          if new_title.match(/\A[a-z0-9\s]+\Z/i)
            status = Note.new.rename(old_title, new_title, book)
          else
            status = {"message"=>"Nombre de nota inválido", "type"=>"error"}
          end
          if status['type'] == 'ok'
            PROMPT.ok(status['message'])
          else
            PROMPT.error(status['message'])
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
          status = Note.new.list(book,global)
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

        def call(title:, **options)
          book = options[:book]
          status = Note.new.show(title, book)
          if status
            PROMPT.error(status['message'])
          end
        end
      end
    end
  end
end
