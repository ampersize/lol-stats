class SummonersController < ApplicationController
	before_action :set_summoner, only: [:show, :edit, :update, :destroy]

	# GET /summoners
	# GET /summoners.json
	def index
		@summoners = Summoner.all

	end

	# GET /summoners/1
	# GET /summoners/1.json
	def show
	end

	# GET /summoners/new
	def new
		@summoner = Summoner.new

	end

	# GET /summoners/1/edit
	def edit
	end

	# POST /summoners
	# POST /summoners.json
	def create
		@summoner = Summoner.new(summoner_params)
		sumname = params[:summoner][:name]
		sumregion = params[:summoner][:region]
		client = RiotLolApi::Client.new(:region => sumregion)
		Rails.logger.debug client.inspect
		# Read Summoner name and then use it to get the corresponding
		# summoner ID from riot
		Rails.logger.info "Searching for summoner name " + sumname
		sumobj = client.get_summoner_by_name sumname
		Rails.logger.debug sumobj.inspect
		respond_to do |format|
			if (sumobj != nil)
				@summoner.summoner_id = sumobj.id.to_s
				Rails.logger.info "Found Summoner #{sumname} with ID: #{sumobj.id.to_s}"
				if @summoner.save
					format.html { redirect_to summoners_path, success: 'Summoner was successfully created.' }
				else
					format.html { redirect_to summoners_path, error: 'Summoner could not be created.' }
				end
			else
				Rails.logger.info "No summoner"
				format.html { render action: 'new', error: 'Summoner could not be found.' }
			end
		end
	end

	# PATCH/PUT /summoners/1
	def update
		respond_to do |format|
			if @summoner.update(summoner_params)
				format.html { redirect_to @summoner, success: 'Summoner was successfully updated.' }
			else
				format.html { render action: 'edit', error: 'Could not update summoner.' }
			end
		end
	end

	# DELETE /summoners/1
	def destroy
		@summoner.destroy
		respond_to do |format|
			format.html { redirect_to summoners_url }
		end
	end

  # Get match history
	def summary
		@summoner = Summoner.find(params[:id])
		client = RiotLolApi::Client.new(:region => @summoner.region)
		sumobj = client.get_summoner_by_name @summoner.name
		@stats = sumobj.stat_summaries
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_summoner
		@summoner = Summoner.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def summoner_params
		params.require(:summoner).permit(:name, :region)
	end
end
