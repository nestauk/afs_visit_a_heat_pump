namespace :scheduler do
  desc 'send notifications'
  task notify: :environment do

    Event.in_3_days.each do |event|
      HostMailer.event_upcoming(event).deliver_now

      event.bookings&.each do |booking|
        VisitorMailer.event_upcoming(event, booking).deliver_now
      end
    end

  end
end
