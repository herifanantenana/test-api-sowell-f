Given("There is string we wish to return") do
  @test = "test string"
end

Then("Cucumber will return the string") do
  puts @test
end
