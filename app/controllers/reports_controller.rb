class ReportsController < ApplicationController
  def balance
    redirect_to root_path, notice: "#{current_user.email}, você recebera um email em instantes !"
    self.mailer
  end
  def mailer
  ReportMailer.send_report(current_user.email).deliver_later
  end
end
