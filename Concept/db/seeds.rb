user = User.create(username: "Juan Perez", email: "juan@mail.com", password: 'blabla', password_confirmation: 'blabla')
  1.upto(rand(1..10)) do |j|
    book = user.books.create title:"Book #{j}"
    1.upto(rand(1..20)) do |k|
      book.notes.create title: "Note #{k} from #{book}", content: "Content for note #{k}", user_id: "#{user.id}"
    end
  end


anotherUser= User.create(username: "Harry Styles", email: "hs@mail.com", password: 'blabla', password_confirmation: 'blabla')
7.times do |j|
  anotherBook = anotherUser.books.create title:"Book #{j}"
  13.times do |k|
    anotherBook.notes.create title: "Note #{k} from #{anotherBook}", content: "Content for note #{k}", user_id: "#{anotherUser.id}"
  end
end
