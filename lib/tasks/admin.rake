namespace :admin do
  desc "send monthly report email"
  task monthly_report: :environment do
    AdminMailer.monthly_report.deliver_late if Time.zone.today.day == Time.zone.today.end_of_month.day
  end
end
