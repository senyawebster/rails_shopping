class OrderItemsController < ApplicationController
  # helper_method :update_quantity
  def create
    @order = current_order
    # OrderItem.update_quantity(@order)
    if @order.order_items.exists?(:product_id => item_params[:product_id])
      order_item = @order.order_items.where(:product_id => item_params[:product_id]).first
      order_item.quantity += item_params[:quantity].to_i
      order_item.save
    else
      @item = @order.order_items.new(item_params)
    end
    if @order.save
      session[:order_id] = @order.id
        flash[:notice] = "This product has been added to your order."
      redirect_to products_path
    else
      flash[:notice] = "There were some errors."
      redirect_to products_path
    end
  end

  def update
    @order = current_order
    @item = @order.order_items.find(params[:id])
    @item.update(:quantity => params[:quantity])
    @order.save
    redirect_to cart_path
    # @item.quantity = item_params[:quantity].to_i
    # @item.save
  end

  def destroy
    @order = current_order
    @item = @order.order_items.find(params[:id])
    @item.destroy
    @order.save
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js { render 'carts/destroy'}
    end
  end

  private

  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
