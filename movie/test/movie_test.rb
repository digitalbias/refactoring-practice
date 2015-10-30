require_relative '../../test_helper'
require_relative '../lib/movie'

class MovieTest < Minitest::Test

  MOVIE_DATA = [
    ["Jaws", RentalPricing::REGULAR], 
    ["Frozen", RentalPricing::CHILDRENS], 
    ["Spectre", RentalPricing::NEW_RELEASE], 
    ["Ghost Busters", RentalPricing::REGULAR]
  ]

  attr_reader :customer

  def setup
    rental_pricing = MOVIE_DATA.collect do |title, price_code| 
      RentalPricing.for(Movie.new(title), price_code)
    end

    @customer = Customer.new("George")

    customer.add_rental(Rental.for(rental_pricing[0], 3))
    customer.add_rental(Rental.for(rental_pricing[1], 2))
    customer.add_rental(Rental.for(rental_pricing[2], 5))
  end

  def test_output_rental_statement
    expected = "Rental Record for George\n" +
      "  Jaws  3.5\n"+
      "  Frozen  1.5\n"+
      "  Spectre  15\n"+
      "Amount owed is 20.0\n"+
      "You earned 4 frequent renter points"

    assert_equal expected, customer.statement
  end

  def test_output_rental_statement_as_html
    # skip
    expected = "<h1>Rentals for <em>George</em></h1><p>\n" +
      "Jaws: 3.5<br>\n" +
      "Frozen: 1.5<br>\n" +
      "Spectre: 15<br>\n" + 
      "<p>You owe <em>20.0</em><p>\n" +
      "On this rental you earned <em>4</em> frequent rental points<p>"

    assert_equal expected, customer.statement(HtmlStatement.new)
  end

end