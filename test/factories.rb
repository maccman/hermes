FactoryGirl.define do
  sequence :uid do |n|
    "#{n}"
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end
  
  sequence :handle do |n|
    "@#{n}"
  end
  
  factory :user do
    uid
    email
    handle
  end
  
  factory :conversation do
    user
    to_users {|c| [c.association(:user)] }
  end
  
  factory :message do 
    body 'A fine message'
    user
    conversation
    association :from_user, :factory => :user 
  end
end