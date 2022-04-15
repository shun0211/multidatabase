class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # connects_to database: :primary
  # connects_to database: { writing: :primary, reading: :primary }
end
