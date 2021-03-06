class Trade < ActiveRecord::Base
  belongs_to :ask
  belongs_to :bid
  has_many :fund_transaction_details

  scope :user_transactions, lambda { |user|
    joins([:bids, :asks]).where('bids.user_id = ? and asks.user_id = ?', user.id, user.id).order(:updated_at).reverse_order
  }
  
  def self.latest_market_price
    Trade.where("market_price IS NOT NULL").last.try(:market_price)
  end

  def sold
    ask.amount.round(2)
  end

  def bought
    bid.amount.round(2)
  end
  
  module Status
    CREATED = :created
    PENDING = :pending
    COMPLETE = :complete
  end
  
  def init_transactions
    if status == Trade::Status::CREATED.to_s
      update_attribute :status, Trade::Status::PENDING
      btc_tx_id = BitcoinProxy.send_from(ask.user.user_wallet.name,
                            bid.user.user_wallet.address,
                            amount + 0.0,
                            "bf-trade #{id}",
                            "bf-trade #{id}",
                            BitcoinProxy.confirm_threshold)
      update_attribute :btc_tx_id, btc_tx_id
    end
  end

  def update_transaction_details
    if status == Trade::Status::PENDING.to_s
      if btc_tx_id
        tx_details = BitcoinProxy.get_transaction btc_tx_id
        _update_transaction_details tx_details
      else
        all_tx_details = BitcoinProxy.list_transactions(ask.user.user_wallet.name, 25)
        comment = "bf-trade #{id}"
        tx_details = all_tx_details.detect do |x_det|
          x_det["category"] == 'send' && x_det["comment"] == comment && x_det["to"] == comment
        end
        _update_transaction_details tx_details
      end
    end
  end
  
  private
  def _update_transaction_details(tx_details)
    fee = tx_details["fee"].try(:to_f).try(:abs)
    if fee && fee > 0.0
      fee_tx = fund_transaction_details.detect { |ftd| ftd.tx_code == FundTransactionDetail::TransactionCode::BITCOIN_FEE.to_s }
      if fee_tx.nil?
        ask.user.btc.debit! :amount => fee,
                            :tx_code => FundTransactionDetail::TransactionCode::BITCOIN_FEE,
                            :currency => 'BTC',
                            :status => FundTransactionDetail::Status::PENDING,
                            :user_id => ask.user.id,
                            :trade_id => id,
                            :ask_id => ask.id,
                            :bid_id => bid.id
      end
      
    end
    
    confirmations = tx_details["confirmations"].to_f
    Rails.logger.info "confirmations ****** #{confirmations}"
    if confirmations >= BitcoinProxy.confirm_threshold
      Trade.transaction do
        update_attribute :status, Trade::Status::COMPLETE
        fund_transaction_details.each {|tx_detail| tx_detail.update_attribute :status, FundTransactionDetail::Status::COMMITTED}
      end
    end
  end
end
