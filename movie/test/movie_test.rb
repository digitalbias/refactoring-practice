require_relative '../../test_helper'
require_relative '../lib/movie'

class BottlesTest < Minitest::Test

  MOVIE_DATA = [
    ["Jaws", Movie::REGULAR], 
    ["Frozen", Movie::CHILDRENS], 
    ["Spectre", Movie::NEW_RELEASE], 
    ["Ghost Busters", Movie::REGULAR]
  ]

  def setup
    movies = MOVIE_DATA.map do |title, price_code|
      Movie.new(title, price_code)
    end

    @customer = Customer.new("George")

    @customer.add_rental(Rental.for(movies[0], 3))
    @customer.add_rental(Rental.for(movies[1], 2))
    @customer.add_rental(Rental.for(movies[2], 5))
  end

  def test_output_rental_statement
    expected = "Rental Record for George\n" +
        "\tJaws\t3.5\n" +
        "\tFrozen\t1.5\n" +
        "\tSpectre\t15\n" +
      "Amount owed is 20.0\n" +
      "You earned 4 frequent renter points"

    assert_equal expected, @customer.statement
  end

  def test_output_rental_statement_as_html

  end

end