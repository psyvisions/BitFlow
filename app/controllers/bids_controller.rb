class BidsController < ApplicationController
  
  PRECISION = 1000000
  # GET /bids
  # GET /bids.xml
  def index
    @bids = current_user.bids.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show
    @bid = Bid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /bids/new
  # GET /bids/new.xml
  def new
    @bid = Bid.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /bids/1/edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
    price = params[:bid][:price].to_f * PRECISION
    @bid = Bid.new(:user_id => current_user.id,:amount => params[:bid][:amount], :price => price, :currency => params[:bid][:currency], :status => Status::ACTIVE)

    respond_to do |format|
      if @bid.save
        format.html { redirect_to(@bid, :notice => 'Bid was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # # PUT /bids/1
  # # PUT /bids/1.xml
  # def update
  #   @bid = Bid.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @bid.update_attributes(params[:bid])
  #       format.html { redirect_to(@bid, :notice => 'Bid was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @bid.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /bids/1
  # # DELETE /bids/1.xml
  # def destroy
  #   @bid = Bid.find(params[:id])
  #   @bid.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(bids_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
