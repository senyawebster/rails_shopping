

class ChargesController < ApplicationController

  def new
    binding.pry
  end

  def create
    # Amount in cents
    @amount = ((current_order.total_price) * 100).to_i
    @order = current_order


    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    current_order.status = 'complete'
    session[:order_id] = nil

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

end
