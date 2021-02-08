user = User.create(username: "Juan Perez", email: "juan@mail.com", password: 'blabla', password_confirmation: 'blabla')
  1.upto(rand(1..20)) do |j|
    book = user.books.create title:"Book #{j}"
    1.upto(rand(1..30)) do |k|
      book.notes.create title: "Note #{k} from #{book.title}", content: "Content for **note #{k}**", user_id: "#{user.id}"
    end
  end


anotherUser= User.create(username: "Harry Styles", email: "hs@mail.com", password: 'blabla', password_confirmation: 'blabla')
1.upto(rand(1..30)) do |j|
  anotherBook = anotherUser.books.create title:"Book #{j}"
  1.upto(rand(1..25)) do |k|
    anotherBook.notes.create title: "Note #{k} from #{anotherBook.title}", content: "# Content for **note #{k}**", user_id: "#{anotherUser.id}"
  end
end



lastUser= User.create(username: "Foxy", email: "fox@mail.com", password: 'blabla', password_confirmation: 'blabla')
1.upto(rand(1..40)) do |l|
  lastBook = lastUser.books.create title:"Book #{l}"
  1.upto(rand(1..20)) do |m|
    lastBook.notes.create title: "> Note #{m} from #{lastBook.title}", content: "### Content for note #{m} ###", user_id: "#{lastUser.id}"
  end
end