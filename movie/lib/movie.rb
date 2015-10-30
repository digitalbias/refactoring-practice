class Movie
  attr_reader :title, :pricing

  def initialize(title, pricing_code = :delete_me)
    @title = title
    @pricing = RentalPricing.for(self, pricing_code)
  end

  def amount(days_rented)
    pricing.amount(days_rented)
  end

  def points(days_rented)
    pricing.points(days_rented)
  end

end

class RentalPricing
  CHILDRENS = 2
  REGULAR = 0
  NEW_RELEASE = 1

  def self.for(movie, price_code = RentalPricing::REGULAR)
    case price_code
    when NEW_RELEASE
      NewReleaseRentalPricing
    when CHILDRENS
      ChildrensRentalPricing
    else
      RentalPricing
    end.new(movie, price_code)
  end

  attr_accessor :movie, :price_code

  def initialize(movie = nil, price_code = RentalPricing::REGULAR)
    @movie = movie
  end

  def amount(days_rented)
    this_amount = 2
    if days_rented > 2
      this_amount += (days_rented - 2) * 1.5
    end
    this_amount
  end

  def points(days_rented)
    1
  end

end

class ChildrensRentalPricing < RentalPricing
  def amount(days_rented)
    this_amount = 1.5
    if (days_rented > 3)
      this_amount += (days_rented - 3) * 1.5
    end
    this_amount
  end
end

class NewReleaseRentalPricing < RentalPricing
  def amount(days_rented)
    this_amount = days_rented * 3
  end

  def points(days_rented)
    super + (days_rented > 1 ? 1 : 0)
  end    
end

class Rental
  attr_reader :movie, :days_rented, :price_code

  def self.for(rental_pricing, days_rented)
    if rental_pricing.kind_of? Movie
      Rental.new(rental_pricing, days_rented)
    else
      Rental.new(rental_pricing.movie, days_rented, rental_pricing)
    end
  end

  def initialize(movie, days_rented, pricing = RentalPricing.new(movie))
    @movie = movie
    @days_rented = days_rented
  end

  def amount
    movie.amount(days_rented)
  end

  def points
    movie.points(days_rented)
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
