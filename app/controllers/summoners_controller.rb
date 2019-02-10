class SummonersController < ApplicationController
	before_action :set_summoner, only: [:show, :edit, :update, :destroy]

	Taric.configure! do |config|
		  config.api_key = 'c3ccb88e-109e-4d1c-81f9-43be4fe90862'
			# config.adapter = :typhoeus # default is Faraday.default_adapter
	end

	# GET /summoners
	# GET /summoners.json
	def index
		@summoners = Summoner.all
		if params[:search]
			@summoners = Summoner.search(params[:search]).order("created_at DESC")
		else
			@summoners = Summoner.all.order('created_at ASC')
		end
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
		if (defined?(RIOT_API_KEY)).nil?
			Rails.logger.debug "Please set API TOKEN"
			flash[:error] = "Please set your API token."
			redirect_to summoners_path and return false
		end
		@summoner = Summoner.new(summoner_params)
		sumname = params[:summoner][:name]
		sumregion = params[:summoner][:region]
		client = Taric.client(:region => sumregion)
		# Read Summoner name and then use it to get the corresponding
		# summoner ID from riot
		Rails.logger.info "Searching for summoner name " + sumname
		sumobj = client.summoner_by_names(summoner_names: sumname).body
		Rails.logger.debug sumobj.inspect
		respond_to do |format|
			unless sumobj.has_key?('status')
				@summoner.summoner_id = sumobj['id'].to_s
				Rails.logger.info "Found Summoner #{sumname} with ID: #{sumobj['id'].to_s}"
				if @summoner.save
					flash[:success] = "Summoner created successful"
					format.html { redirect_to summoners_path }
				else
					flash[:error] = "Summoner could not be created successful"
					format.html { render action: 'new' }
				end
			else
				Rails.logger.info "Summoner could not be found"
				Rails.logger.debug sumobj.inspect
				flash[:error] = "Summoner could not be found"
				format.html { render action: 'new' }
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
		client = Taric.client(:region => @summoner.region)
		@stats = client.summary_stats(summoner_id: @summoner.summoner_id).body
	end

	def games
		@summoner = Summoner.find(params[:id])
		@client = Taric.client(:region => @summoner.region)
		@summoners = Summoner.all
		@games = @client.recent_games(:summoner_id => @summoner.summoner_id).body
		@champions = @client.static_champions(data_by_id: true, champ_data_option: 'all').body['data']
		@items = @client.static_items.body['data']
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
