# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

BankAccount.delete_all
BankAccount.create(id: 1, name: "Основной в Банк1")

Cashbox.delete_all
Cashbox.create([{id: 1, name: "Касса грн"}, {id: 2, name: "Касса usd"}])