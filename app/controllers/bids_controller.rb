class BidsController < ApplicationController

  def index
    @bids = current_user.bids.all
  end

  def show
    @bid = Bid.find(params[:id])
  end

  def new
    @bid = Bid.new
  end

  def create
    @bid = Bid.new(:user_id => current_user.id, 
                   :amount => params[:bid][:amount], 
                   :price => params[:bid][:price], 
                   :status => Order::Status::ACTIVE)

    respond_to do |format|
      if @bid.save
        format.html { redirect_to(orders_url, :notice => 'Bid was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @bid = Bid.find(params[:id])
    @bid.update_attribute :status, Order::Status::CANCELLED
    Fund.update_buyer_usd_fund_on_cancel @bid
    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
