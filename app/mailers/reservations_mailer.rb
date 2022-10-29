#TODO send email on confirmation of reservation
class ReservationsMailer < ApplicationMailer

  def confirmed_reservation
    @reservation = params[:reservation]
    @url  = 'http://example.com/login'
    mail(to: @reservation.email, subject: 'Your tree pickup is confirmed')
  end
end
