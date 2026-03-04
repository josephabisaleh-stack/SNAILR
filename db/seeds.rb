puts "Cleaning database..."
Message.destroy_all
Chat.destroy_all
Step.destroy_all
Objective.destroy_all
User.destroy_all

# Creating data
puts "Creating users..."
joseph = User.create!(
  email: "joseph@example.com",
  password: "password",
  first_name: "Joseph",
  last_name: "Abisaleh",
  display_name: "Snail_Master",
)

matteo = User.create!(
  email: "matteo@example.com",
  password: "password",
  first_name: "Matteo",
  last_name: "Bouquet",
  display_name: "Mat",
)

puts "Creating objectives & their steps..."

## mastering rails

objective = Objective.create!(
  user: joseph,
  title: "Master full stack AI",
  description: "Build a complete SaaS application using the latest Rails features.",
  status: "completed",
  progress: 100
)

Step.create!(
  objective: objective,
  done: true,
  position: 1,
  title: "Become a Ruby star",
  xp_reward: 50
)

Step.create!(
  objective: objective,
  done: true,
  position: 2,
  title: "Become a front-end development star",
  xp_reward: 30
)

Step.create!(
  objective: objective,
  done: true,
  position: 3,
  title: "Master LLM",
  xp_reward: 20
)

joseph.update!(total_xp: joseph.total_xp + objective.steps.done.sum(:xp_reward))

## mont ventoux

objective = Objective.create!(
  user: joseph,
  title: "Climb Mont Ventoux by bike",
  description: "Necessary steps to succeed",
  status: "in_progress",
  progress: 20
)

Step.create!(
  objective: objective,
  done: true,
  position: 1,
  title: "Buy a bike",
  xp_reward: 10
)

Step.create!(
  objective: objective,
  done: false,
  position: 2,
  title: "Lose 5 kilogrammes",
  xp_reward: 300
)

Step.create!(
  objective: objective,
  done: false,
  position: 3,
  title: "Stop going to restaurant all the time",
  xp_reward: 250
)

Step.create!(
  objective: objective,
  done: false,
  position: 4,
  title: "Wake up at 5 am to exercise",
  xp_reward: 800
)

Step.create!(
  objective: objective,
  done: false,
  position: 5,
  title: "Spike the opponents' tires",
  xp_reward: 5
)

joseph.update!(total_xp: joseph.total_xp + objective.steps.done.sum(:xp_reward))

## matteo objective

objective = Objective.create!(
  user: matteo,
  title: "Become an adult",
  description: "Study to work",
  status: "in_progress",
  progress: 50
)

Step.create!(
  objective: objective,
  done: false,
  position: 1,
  title: "Leave parents'home",
  xp_reward: 50
)
matteo.update!(total_xp: matteo.total_xp + objective.steps.done.sum(:xp_reward))

puts "Finished seeding!"
