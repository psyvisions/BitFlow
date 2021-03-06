module FundWithdrawRequestsHelper
  def append_currency_to_amount fund_withdraw_request
    "#{fund_withdraw_request.amount.to_f} #{fund_withdraw_request.currency}"
  end
  
  def explain_status fund_withdraw_request
    if fund_withdraw_request.status.to_s == FundWithdrawRequest::Status::DECLINED.to_s
      if fund_withdraw_request.status_comment.blank?
        fund_withdraw_request.status
      else
        "#{fund_withdraw_request.status}:#{fund_withdraw_request.status_comment}"
      end
    else
      fund_withdraw_request.status
    end
  end
end
