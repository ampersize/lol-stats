class Summoner < ActiveRecord::Base
	validates :name, uniqueness: true

	def self.search(search)
		where("name LIKE ?", "%#{search}%")
	end
end
