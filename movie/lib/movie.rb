class Movie
  CHILDRENS = 2
  REGULAR = 0
  NEW_RELEASE = 1

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title = title
    @price_code = price_code
  end

end

class Rental
  attr_reader :movie, :days_rented

  def self.for(movie, days_rented)
    case movie.price_code
    when Movie::NEW_RELEASE
      NewReleaseRental.new(movie, days_rented)
    when Movie::CHILDRENS
      ChildrensRental.new(movie, days_rented)
    else
      Rental.new(movie, days_rented)
    end
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
    extra_points = days_rented > 1 ? 1 : 0
    super + extra_points
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

  def statement
    Statement.new.print(self)
  end

end

class Statement

  def print(customer)
    total_amount = 0
    frequent_renter_points = 0
    result = "Rental Record for #{customer.name}\n"
    customer.rentals.each do |rental|
      # show figures for this rental
      result << "\t#{rental.movie.title}\t#{rental.amount}\n"

      frequent_renter_points += rental.points
      total_amount += rental.amount
    end
    # add footer lines
    result << "Amount owed is #{total_amount}\n"
    result << "You earned #{frequent_renter_points} frequent renter points"
    result
  end

end

