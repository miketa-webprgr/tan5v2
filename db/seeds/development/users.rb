User.create!(
  email: "a@a.com",
  name: "taro",
  password: "password",
  suspended: false,
  profile: "hello",
  admin: true
)



25.times do |n|
  moji = (n + 98).chr
  

  User.create!(
   name: "No. #{n}",
    email: "#{moji}@#{moji}.com",
    password: "password",
    profile: "#{moji*10}"
  )
end
