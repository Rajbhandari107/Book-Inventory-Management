from flask import Flask, request, jsonify, render_template, redirect, url_for
import pymysql

app = Flask(__name__)

# Database connection parameters
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'RA2311026011107',
    'database': 'InventoryDB',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_db_connection():
    connection = pymysql.connect(**db_config)
    return connection

@app.route('/')
def index():
    # Show main page with books list
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM BooksWithAuthors")
            books = cursor.fetchall()
    finally:
        connection.close()
    return render_template('index.html', books=books)

@app.route('/books/add', methods=['POST'])
def add_book():
    title = request.form.get('title')
    author_id = request.form.get('author_id')
    category_id = request.form.get('category_id')
    price = request.form.get('price')
    stock_quantity = request.form.get('stock_quantity')

    if not (title and author_id and price and stock_quantity):
        return "Missing required fields", 400

    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            sql = """
            INSERT INTO Books (Title, AuthorID, CategoryID, Price, StockQuantity)
            VALUES (%s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (title, author_id, category_id or None, price, stock_quantity))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('index'))

@app.route('/books/delete/<int:book_id>', methods=['POST'])
def delete_book(book_id):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM Books WHERE BookID = %s", (book_id,))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('index'))

# New routes for Authors
@app.route('/authors')
def authors():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM Authors")
            authors = cursor.fetchall()
    finally:
        connection.close()
    return render_template('authors.html', authors=authors)

@app.route('/authors/add', methods=['POST'])
def add_author():
    author_name = request.form.get('author_name')
    if not author_name:
        return "Author name is required", 400
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO Authors (AuthorName) VALUES (%s)", (author_name,))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('authors'))

@app.route('/authors/delete/<int:author_id>', methods=['POST'])
def delete_author(author_id):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM Authors WHERE AuthorID = %s", (author_id,))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('authors'))

# New routes for Categories
@app.route('/categories')
def categories():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM Categories")
            categories = cursor.fetchall()
    finally:
        connection.close()
    return render_template('categories.html', categories=categories)

@app.route('/categories/add', methods=['POST'])
def add_category():
    category_name = request.form.get('category_name')
    if not category_name:
        return "Category name is required", 400
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO Categories (CategoryName) VALUES (%s)", (category_name,))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('categories'))

@app.route('/categories/delete/<int:category_id>', methods=['POST'])
def delete_category(category_id):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM Categories WHERE CategoryID = %s", (category_id,))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('categories'))

# New routes for Customers
@app.route('/customers')
def customers():
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM Customers")
            customers = cursor.fetchall()
    finally:
        connection.close()
    return render_template('customers.html', customers=customers)

@app.route('/customers/add', methods=['POST'])
def add_customer():
    first_name = request.form.get('first_name')
    last_name = request.form.get('last_name')
    email = request.form.get('email')
    if not (first_name and last_name and email):
        return "All fields are required", 400
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO Customers (FirstName, LastName, Email) VALUES (%s, %s, %s)",
                (first_name, last_name, email)
            )
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('customers'))

@app.route('/customers/delete/<int:customer_id>', methods=['POST'])
def delete_customer(customer_id):
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM Customers WHERE CustomerID = %s", (customer_id,))
        connection.commit()
    finally:
        connection.close()
    return redirect(url_for('customers'))

if __name__ == '__main__':
    app.run(debug=True)
