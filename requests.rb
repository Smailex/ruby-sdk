38ddd2ddee5e8e3aa5ccae5471af1da64cbb6d7f36939cdf7d2fd754f7820347


#party
{:line1=> "1 Infinite Loop",:city=> "Cupertino",:state=> "CA",:zip=> "95014",:country=> "US",:residential=> false,:name=> "DONALD",:company=> "DISNEY",:phone=> "1234567890",:email=> "donald.duck@disney.com"}

{
  :line1=> "1 Infinite Loop",
  :city=> "Cupertino",
  :state=> "CA",
  :zip=> "95014",
  :country=> "US",
  :residential=> false,
  :name=> "DONALD",
  :company=> "DISNEY",
  :phone=> "1234567890",
  :email=> "donald.duck@disney.com"
}

#party 2
{
  :line1=> "11811 north fwy",
  :line2 => "ste 500",
  :city=> "Houston",
  :state=> "TX",
  :zip=> "77060",
  :country=> "US",
  :name=> "DONALD",
  :company=> "DISNEY",
  :phone=> "1234567890"
}

# packages
{:title => "My default",:length=> 1,:width=> 1,:height=> 3}

[
  {
    :title => "My default",
    :length=> 1,
    :width=> 1,
    :height=> 3,
    :weight=> 3.1,
  }
]

# Carrier
{
  :name=> "ups",
  :service=> "1day",
  :credentials=> "weship"
}

# options
{
  :signature_type=> "adult",
  :label_type=> "pdf",
  :remarks=> "user defined marks for shipment"
}

{  :saturday_delivery => true }

# tracking
{:carrier=> "FedEx",:tracking_number=> "794825154413"}


# shipment
{:from=>{:line1=>"1 Infinite Loop",:city=>"Cupertino",:state=>"CA",:zip=>"95014",:country=>"US",:name=> "Sender Name",:company=> "Sender company",:phone=> "1234567890",:email=> "test@example.com"},:to=>{:line1=>"1600 Amphitheatre Pkwy",:city=>"Mountain View",:state=>"CA",:zip=>"94043",:country=>"US",:name=>"Receiver name",:company=>"Receiver company",:phone=>"1234567890",:email=>"test@receiver.com"},:package_type=> "box",:packages=>[{:length=>1,:width=>1,:height=>3,:weight=>3.1,:insured_value=> "1000"}],:carrier=> {:name=> "FEDEX",:service=> "1day",:credentials=> "WESHIP"}, :options =>{:signature_type=>"adult", :remarks=>"SDK", :saturday_delivery=>false}}

{:from=>{:line1=>"1 Infinite Loop",:city=>"Cupertino",:state=>"CA",:zip=>"95014",:country=>"US",:name=> "Sender Name",:company=> "Sender company",:phone=> "1234567890",:email=> "test@example.com"},:to=>{:line1=>"1600 Amphitheatre Pkwy",:city=>"Mountain View",:state=>"CA",:zip=>"94043",:country=>"US",:name=>"Receiver name",:company=>"Receiver company",:phone=>"1234567890",:email=>"test@receiver.com"},:package_type=> "box",:packages=>[{:length=>1,:width=>1,:height=>3,:weight=>3.1,:insured_value=> "1000"}, {:length=>1,:width=>1,:height=>3,:weight=>3.1,:insured_value=> "1000"}],:carrier=> {:name=> "FEDEX",:service=> "1day",:credentials=> "WESHIP"}, :options =>{:signature_type=>"adult", :remarks=>"SDK", :saturday_delivery=>false}}


{:from=>{:line1=>"1 Infinite Loop",:city=>"Cupertino",:state=>"CA",:zip=>"95014",:country=>"US",:name=> "Sender Name",:company=> "Sender company",:phone=> "1234567890",:email=> "test@example.com"},:to=>{:line1=>"1600 Amphitheatre Pkwy",:city=>"Mountain View",:state=>"CA",:zip=>"94043",:country=>"US",:name=>"Receiver name",:company=>"Receiver company",:phone=>"1234567890",:email=>"test@receiver.com"},:package_type=> "box",:packages=>[{:length=>1,:width=>1,:height=>3,:weight=>3.1,:insured_value=> "1000"}, {:title=>"test", :weight=>1,:insured_value=>50}],:carrier=> {:name=> "FEDEX",:service=> "1day",:credentials=> "WESHIP"}, :options =>{:signature_type=>"adult", :remarks=>"SDK", :saturday_delivery=>false}}



# simple rates
{:from_zip=> "77060",:to_zip=> "94040",:residential=> true,:carrier=> {:name=> "UPS",:service=>"ground",:credentials=>"WESHIP"},:packages=> [{:weight=>3,:length=>1,:width=>1,:height=>3}]}