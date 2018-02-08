module FactoryBot
  def FactoryBot.random_string(length=8)
    (0...length).map { (65 + rand(26)).chr }.join
  end
end