module FactoryBot
  def FactoryBot.random_string(length=8)
    (0...length).map { (65 + rand(26)).chr }.join
  end

  def FactoryBot.random_float(min=0.0, max=1000.0)
    (rand * (max - min)) + min
  end
end