CREATE DATABASE IF NOT EXISTS community_library;
USE community_library;

CREATE TABLE members (
    member_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30),
    joined_at DATE NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE books (
    book_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(160) NOT NULL,
    publication_year YEAR,
    genre VARCHAR(80),
    copies_total SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    copies_available SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT chk_book_copies CHECK (
        copies_available <= copies_total
    )
);

CREATE TABLE loans (
    loan_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id INT UNSIGNED NOT NULL,
    book_id INT UNSIGNED NOT NULL,
    borrowed_at DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_at DATE NOT NULL,
    returned_at DATE,
    CONSTRAINT fk_loans_member FOREIGN KEY (member_id)
        REFERENCES members(member_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_loans_book FOREIGN KEY (book_id)
        REFERENCES books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_loan_dates CHECK (
        due_at >= borrowed_at AND (returned_at IS NULL OR returned_at >= borrowed_at)
    ),
    INDEX idx_loans_member_status (member_id, returned_at),
    INDEX idx_loans_book_status (book_id, returned_at)
);
