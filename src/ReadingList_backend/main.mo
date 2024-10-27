import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor {
  type BookId = Nat;
  
  type Book = {
    id: BookId;
    title: Text;
    author: Text;
    status: Text; // "not started", "in progress", "completed"
  };

  var books = Buffer.Buffer<Book>(0);

  public func addBook(title: Text, author: Text) : async BookId {
    let bookId = books.size();
    let newBook: Book = {
      id = bookId;
      title = title;
      author = author;
      status = "not started";
    };
    books.add(newBook);
    bookId
  };

  public func updateStatus(bookId: BookId, newStatus: Text) : async Bool {
    if (bookId >= books.size()) return false;
    let book = books.get(bookId);
    let updatedBook: Book = {
      id = book.id;
      title = book.title;
      author = book.author;
      status = newStatus;
    };
    books.put(bookId, updatedBook);
    true
  };

  public query func getBook(bookId: BookId) : async ?Book {
    if (bookId < books.size()) {
      ?books.get(bookId);
    } else {
      null;
    };
  };

  public query func getAllBooks() : async [Book] {
    Buffer.toArray(books)
  };

  public query func getBooksByStatus(status: Text) : async [Book] {
    let results = Buffer.Buffer<Book>(0);
    for (book in books.vals()) {
      if (Text.equal(book.status, status)) {
        results.add(book);
      };
    };
    Buffer.toArray(results)
  };
}