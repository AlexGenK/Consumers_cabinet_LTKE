require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#
s.cron('10 22 * * *') do
  Rails.logger.info "hello, it's Rufus Scheduler - #{Time.now}"
  Rails.logger.flush
end
