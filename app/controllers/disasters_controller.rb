class DisastersController < ApplicationController
	before_action :authenticate_user!, :except => [:index,:edit]
	before_action :set_disaster, :only =>[:show,:edit,:update,:destroy]
	def index

		@disasters = Disaster.page(params[:page]).per(5)
		prepare_variable_for_index_template
		
	end
	def new
		@disaster = Disaster.new
	end
	# GET /disasters/about
	def about
		@users = User.all
		@messages = Message.all
		@disasters = Disaster.all
	end
	def show
		@messages = @disaster.messages
	    @disaster_message = Message.new  #new出來的物件用來給form_for塞進來的資料

	end
	def create
		@disaster = Disaster.new(params_disaster)
		@disaster.user = current_user
		if @disaster.save
		flash[:notice]="新增成功！！"
		redirect_to disasters_path
		else
		flash[:alert]="新增失敗！！"
		render :action => :new
		end
	end
	def edit
		
	end
	def update
		@disaster.update(params_disaster)
		redirect_to disasters_path
	end
    def destroy
    	@disaster.destroy
    	redirect_to disasters_path(:page=>params[:page])
    end
    
    private #private 底下的方法只有自己的class可以用
    def params_disaster
    	params.require(:disaster).permit(:category,:title,:content,:group_ids=>[])
    end
    def set_disaster
    	@disaster = Disaster.find(params[:id])
    end
    def prepare_variable_for_index_template
		if  params[:order] == "title"
    		@disasters = @disasters.order("title")
    	elsif  params[:order]=="messages_count"
    		@disasters = @disasters.order("messages_count DESC")
    	else
    		@disasters
    	end
    end
end
