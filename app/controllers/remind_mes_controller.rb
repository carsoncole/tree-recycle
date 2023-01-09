class RemindMesController < ApplicationController
  def show
    flash.clear
    @remind_me = RemindMe.find(params[:id])
  end

  def create
    @remind_me = RemindMe.new(remind_me_params)

    if @remind_me.save
      redirect_to remind_me_url(@remind_me)
    else
      redirect_to root_url, notice: "Ooops. Something went wrong. Can you try submitting your name and email again?"
    end
  end

  private

  def remind_me_params
    params.require(:remind_me).permit(:name, :email)
  end
end
