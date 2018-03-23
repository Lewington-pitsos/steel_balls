# Steel Ball Problem Solver®

## Overview

Tired of spending hours every day having to solve variants of the [Steel Ball Problem](http://weteachscience.org/mentoring/resources/lesson-plans/eight-balls-weighing-problem-logic)? Now there is a better way! With the **Steel Ball Problem Solver®** your [Steel Ball Problem](http://www.mytechinterviews.com/8-identical-balls-problem) solving needs can be met at the click of a button. We use the latest technology combined with Cutting Edge Science to bring you the **Steel Ball Problem Solver®**: a user-friendly app that lets you solve [Steel Ball Problem](https://www.quora.com/There-are-eight-balls-Seven-of-them-weigh-the-same-but-one-of-them-has-a-different-weight-heavier-or-lighter-How-do-you-find-the-odd-ball-with-two-weighs)s just like that!

## Functionality

Oh boy is it ever functional! It doesn't actually have many functions though, at the moment it only tells you *how many weighs* you will need to make in order to work out the odd ball, not what weighs to actually make. So yes, somehow even less useful than it seemed at first, but hey at least it's accurate.

It stores all the results it gets in a huge database so running it for the same number of balls twice should be pretty much instant.

#### notes

- It takes a while to calculate larger numbers so be chill
- Yes I am currently working on getting it to tell us how it reaches it's conclusions, fear not.

## Usage

I mean, like, don't but just in case you're mad...

1. Clone it somewhere or other (I like to put all my files in `/bin`)
2. `bundle install` in the project directory
3. Hang on, I assumed you already had ruby installed. If you didn't go and install ruby and do 2. again.
4. Install bundler, that's important to. step 2. won't work unless you have the bundler gem installed.
5. Ok, things are looking good. The program is executed through the `project_directory/rubyscripts/logic/interface.rb` file, so just `cd` into the project directory and type `bundle exec ruby rubyscripts/logic/interface.rb`
6. Oh no, It didn't work! You also need to have a working postgresql server running on your machine AND, get this: an empty database called `steel_balls`.
7. AND, Christ, you need to make sure that the postgres user can access that database without needing a password.
8. ok, if that's all done, do 5 again and it **should** work. Terminal prompts should walk you through the rest.
