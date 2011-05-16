class Setup < ActiveRecord::Base

  def self.done
    Setup.first.setup_completed == true
  end
end
