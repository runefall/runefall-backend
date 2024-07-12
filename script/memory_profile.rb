# script/memory_profile.rb

require 'memory_profiler'
require './config/environment.rb'
require 'kaminari'

report = MemoryProfiler.report do
  # Code you want to profile. For example, a controller action.
  100.times do
    
    # Card.where("card_code = '01IO015T1'")
    cards = Card.page(1).per(25)
    render json: CardSerializer.new(cards)
  end
end

report.pretty_print(to_file: 'memory_profile_report.txt')