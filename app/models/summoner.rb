class Summoner < ActiveRecord::Base
	validates :name, uniqueness: true
end
