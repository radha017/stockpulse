class Stock < ApplicationRecord
    validates :symbol, uniqueness: true

end
