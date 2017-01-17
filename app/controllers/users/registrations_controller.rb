class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource| # Extend Devise function and add on functionality
      if params[:plan] # Check if user is coming in as Basic or Pro
        resource.plan_id = params[:plan]
        if resource.plan_id == 2
          resource.save_with_subscription
        else
          resource.save
        end
      end
    end
  end # END 'create'
end