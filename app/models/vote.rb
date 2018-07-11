class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
end
