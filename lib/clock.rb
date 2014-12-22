require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  every(10.minutes, 'Perform selection') { Delayed::Job.enqueue SelectionJob.new}
end