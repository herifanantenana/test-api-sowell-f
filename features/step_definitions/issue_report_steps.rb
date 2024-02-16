Given("I am create an User") do
  @user = User.create!(
    fname: Faker::Name.first_name,
    lname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: "pass123456"
  )
  expect(User.count).to be(1)
end

And("I create a new Role superadmin for this user") do
  Role.create!(
    name: "superadmin",
    user_id: @user.id,
  )
  expect(Role.count).to be(1)
end

Then("I create a new issue report logged in as this user") do
  company = Company.create!(
    name: Faker::Company.name,
    logo_url: Faker::Internet.url,
    logo_base64: Faker::Internet.url
  )
  agency = Agency.create!(
    name: Faker::Company.name,
    company: company
  )
  residence = Residence.create!(
    name: Faker::Name.initials,
    company: company,
    agency: agency
  )
  place = Place.create!(
    name: Faker::Company.name,
    zip: Faker::Address.zip,
    city: Faker::Address.city,
    country: Faker::Address.country,
    company: company,
    residence: residence
  )
  location_type = LocationType.create!(
    name: Faker::Name.initials,
    logo_url: Faker::Internet.url,
    company: company,
    nature: :other_spots
  )
  issue_type = IssueType.create!(
    name: Faker::Company.name,
    company: company,
    logo_url: Faker::Internet.url,
    location_type: location_type
  )

  header "Authorization", "Bearer #{JsonWebToken.encode({uid: @user.id})}"
  params = {
    data: {
      type: "issue_reports",
      attributes: {
        priority: :low,
        message: Faker::Lorem.sentence,
        company_id: company.id,
        place_id: place.id,
        issue_type_id: issue_type.id,
        author_id: @user.id
      }
    }
  }
  res = send :post, issue_reports_path, params
  expect(res.status).to eq(201)
end

And("I should see the issue report in the list of issue reports") do
  header "Authorization", "Bearer #{JsonWebToken.encode({uid: @user.id})}"
  res = send :get, issue_reports_path
  expect(res.status).to eq(200)
  expect(IssueReport.count).to eq(1)
  #expect(JSON.parse(res.body)["data"].first["attributes"]["author_id"]).to eq(@user.id)
end
