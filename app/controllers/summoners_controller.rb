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
		sumregion = params[:summoner][:region] || "euw"
		client = RiotLolApi::Client.new(:region => sumregion)
		Rails.logger.debug client.inspect
		# Read Summoner name and then use it to get the corresponding
		# summoner ID from riot
		Rails.logger.info "Searching for summoner name " + sumname
		sumobj = client.get_summoner_by_name sumname
		Rails.logger.debug sumobj.inspect
		if sumobj.success?
			Rails.logger.info "Found Summoner #{sumname} with ID: #{sumobj.id.to_s}"
			if @summoner.save
				format.html { redirect_to summoners_path, success: 'Summoner was successfully created.' }
			else
				format.html { redirect_to summoners_path, error: 'Summoner could not be created.' }
			end
		else
			format.html { redirect_to summoners_path, error: 'Summoner could not be found. Please check summoner name' }
		end
	end

	# PATCH/PUT /summoners/1
	# PATCH/PUT /summoners/1.json
	def update
		respond_to do |format|
			if @summoner.update(summoner_params)
				format.html { redirect_to @summoner, notice: 'Summoner was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @summoner.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /summoners/1
	# DELETE /summoners/1.json
	def destroy
		@summoner.destroy
		respond_to do |format|
			format.html { redirect_to summoners_url }
			format.json { head :no_content }
		end
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
