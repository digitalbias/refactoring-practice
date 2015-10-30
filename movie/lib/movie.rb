class Movie
  attr_reader :title

  def initialize(title)
    @title = title
  end
end

class RentalPricing
  attr_accessor :movie, :price_code

  def initialize(movie, price_code = Rental::REGULAR)
    @movie = movie
    @price_code = price_code
  end
end

class Rental
  CHILDRENS = 2
  REGULAR = 0
  NEW_RELEASE = 1

  attr_reader :movie, :days_rented, :price_code

  def self.for(rental_pricing, days_rented)
    case rental_pricing.price_code
    when NEW_RELEASE
      NewReleaseRental
    when CHILDRENS
      ChildrensRental
    else
      Rental
    end.new(rental_pricing.movie, days_rented)
  end

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def amount
    this_amount = 2
    if days_rented > 2
      this_amount += (days_rented - 2) * 1.5
    end
    this_amount
  end

  def points
    1
  end    

end

class ChildrensRental < Rental
  def amount
    # TODO: This calculation looks a lot like the base class calculation with some differences in amounts....
    this_amount = 1.5
    if (days_rented > 3)
      this_amount += (days_rented - 3) * 1.5
    end
    this_amount
  end
end

class NewReleaseRental < Rental
  def amount
    this_amount = days_rented * 3
  end

 def points
    # add bonus for a two day new release rental
    super + (days_rented > 1 ? 1 : 0)
  end    

end

class Customer
  attr_reader :name, :rentals

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(rental)
    @rentals << rental
  end

  def statement(formatter = TextStatement.new)
    formatter.print(self)
  end

  def frequent_renter_points
    rentals.collect(&:points).inject(:+)
  end

  def total_amount
    rentals.collect(&:amount).inject(:+)
  end

end

class TextStatement

  def print(customer)
    result = "Rental Record for #{customer.name}\n"
    result << customer.rentals.collect { |rental| "  #{rental.movie.title}  #{rental.amount}"}.join("\n") + "\n"
    result << "Amount owed is #{customer.total_amount}\n"
    result << "You earned #{customer.frequent_renter_points} frequent renter points"
    result
  end
end

class HtmlStatement
  def print(customer)
    result = "<h1>Rentals for <em>#{customer.name}</em></h1><p>\n"
    result << customer.rentals.collect{|rental| "#{rental.movie.title}: #{rental.amount}<br>"}.join("\n") + "\n"
    result << "<p>You owe <em>#{customer.total_amount}</em><p>\n"
    result << "On this rental you earned <em>#{customer.frequent_renter_points}</em> frequent rental points<p>"
    result
  end
end
