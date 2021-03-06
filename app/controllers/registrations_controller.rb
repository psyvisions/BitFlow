class RegistrationsController < Devise::RegistrationsController

  def new
    referrer_code = params[:referrer_code]
    resource = build_resource({:referrer_code => referrer_code})
    respond_with_navigational(resource){ render_with_scope :new }
  end

  def create
    if verify_recaptcha
      referrer_code = params[:user][:referrer_code]
      if referrer_code.blank?
        super
      else
        referrer = User.where(:referral_code => referrer_code).first
        if referrer.nil?
          build_resource
          clean_up_passwords(resource)
          flash.now[:alert] = "Referral Code doesn't exist. Please enter a valid one or clear it before submitting again."
          render_with_scope :new
        else
          super
        end
      end
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code and click submit."
      render_with_scope :new
    end
  end

end