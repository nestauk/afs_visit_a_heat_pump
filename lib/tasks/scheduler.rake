namespace :scheduler do
  desc 'Send reminder emails when events in 3 days, usage: `rake scheduler:notify`'
  task notify: :environment do

    Event.in_3_days.each do |event|
      HostMailer.event_upcoming(event).deliver_now

      event.bookings&.each do |booking|
        VisitorMailer.event_upcoming(event, booking).deliver_now
      end
    end

  end
end
