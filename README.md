# Steel Ball Problem Solver®

## Overview

Tired of spending hours every day having to solve variants of the [Steel Ball Problem](http://weteachscience.org/mentoring/resources/lesson-plans/eight-balls-weighing-problem-logic)? Now there is a better way! With the **Steel Ball Problem Solver®** your [Steel Ball Problem](http://www.mytechinterviews.com/8-identical-balls-problem) solving needs can be met at the click of a button. We use the latest technology combined with Cutting Edge Science to bring you the **Steel Ball Problem Solver®**: a user-friendly app that lets you solve [Steel Ball Problem](https://www.quora.com/There-are-eight-balls-Seven-of-them-weigh-the-same-but-one-of-them-has-a-different-weight-heavier-or-lighter-How-do-you-find-the-odd-ball-with-two-weighs)s just like that!

## Functionality

You give it a number of balls. It gives you back:

1. However many weighs it will take to know *for sure* which ball is the oddball *and* whether it is heavier or lighter.
2. A yaml-encoded ruby hash representing a single selection tree you could follow to achieve that result.

#### notes

- It takes a while to calculate larger numbers.
- The tree output is hideous to look at.
- the program actually calculates all possible selection trees, but I thought I'd cut down the data it actually shows to make it a bit less hideous to look at.
- `./design_files` has a lot of useful information.

## Usage

I mean, like, don't but just in case you're mad...

1. Have Ruby, Bundler and PostgreSQL installed on your machine.
2. Clone the project somewhere or other
3. `bundle install` in the project directory
4. Make sure a postgres server is running and that the `postgres` user can access the server without any weird authentication stuff.
5. `cd` into the project directory and run `bundle exec ruby db_reset.rb` to create the required databases on the postgres server.
6. If that went well everything should be working. The program is executed through the `project_directory/run.rb` file, so again, just `cd` into the project directory and type `bundle exec ruby run.rb`
