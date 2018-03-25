# LEGEND

This file contains a bunch of term definitions for clarifying the design files below.


#### Balance State

A hash containing 4 arrays of ball objects, each representing a possible weigh outcome for that ball.

```ruby
{
  unweighed: [],
  lighter: [],
  heavier: [],
  balanced: []
}
```

Either the scale balanced , in which case each ball will either go into the `:balanced` or `:unweighed` categories, or it tipped, in which case, depending on the tip, the balls that went up will be categorized as `:lighter` and the heavier ones as `:heavier` (the unweighed balls remain `:unweighed`).

#### Balance State, Converted

Exactly the same, except each ball has been given a new mark depending on how the weigh turned out. For instance, an `:unknown` ball that ended up in the `:lighter` category, will now be marked as `:possibly_lighter`. Similarly, an `:unweighed`, `:unknown` ball will be marked `:normal` if the scale tipped, since we know the oddball must be among the balls weighed.

#### Ball Object

It's pretty much almost a hash. It keeps track of its own weight and mark.

see `rubyscripts/logic/state_evaluator/selection_overseer/state_expander/arrangement_generator/ball_generator/ball.rb`


#### Ball Arrangement

This represents a possible way that the balls we are working with could be, given that we only have access to the ball marks and not the ball weights. For instance, the following **Ball State**:

```ruby
{
  unknown: 2,
  possibly_lighter: 0,
  possibly_heavier: 1,
  normal: 1

}
```

could represent any of 5 different **Ball Arrangements**, since there are three balls that could be the oddball, and for two of those balls, the oddball could be heavier or lighter. These are encoded as an array of **Ball Objects** where at least one ball is an oddball.

#### Ball state:

A simple hash that represents a number of balls and their marks. It is often used to represent the *entire* collection of balls that exists (as in **StataManager** or **SelectionOverseer** ), but it can also represent a subset of these (as in **SelectionGenerator** ).

```ruby
{
  unknown: 6,
  possibly_lighter: 1,
  possibly_heavier: 1,
  normal: 0

}
```

This represents a state of 8 balls, 6 of which are marked 'unknown'.


#### Rating

An estimation of the distance between a given state or selection and a winning state. The higher the rating the closer we should be.


#### Score
The (exact) number of steps between a selecton or state and a winning state. Winning states are considered to have a score of 0. Selections have the same score as their highest scored resulting state.

#### Selection Order, Simple

A hash with a `:left` and a `:right` key, both of which point to a ball state. These are used to represent a possible selection of balls for weighing (i.e. balls to weigh on the left and balls to weigh on the right).

See:

```ruby
{
  left: {
    unknown: 0,
    possibly_lighter: 1,
    possibly_heavier: 1,
    normal: 0
  },
  right: {
    unknown: 2,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }
}
```


#### Selection Order, Complex

A selection state representing balls to weigh on the left mapped to an array of further selection states, each representing balls to weigh on the right. This is a more compact way of storing selection data than a **Simple Selection Order**.

```ruby
{
  left: {
    unknown: 0,
    possibly_lighter: 1,
    possibly_heavier: 1,
    normal: 0
  },
  right: [
    {
      unknown: 2,
      possibly_lighter: 0,
      possibly_heavier: 0,
      normal: 0
    },
    {
      unknown: 0,
      possibly_lighter: 1,
      possibly_heavier: 1,
      normal: 0
    },
    {
      unknown: 1,
      possibly_lighter: 1,
      possibly_heavier: 0,
      normal: 0
    }
  ]
}
```



#### Selection State

A ball state of a given length (i.e. number of balls) which represents a subset of some all the balls represented by some other ball state.

If this is a ball state (superstate):

```ruby
{
  unknown: 6,
  possibly_lighter: 1,
  possibly_heavier: 1,
  normal: 0

}
```

This would constitute a Selection state of length 3 which is a subset of the superstate above:

```ruby
{
  unknown: 2,
  possibly_lighter: 1,
  possibly_heavier: 0,
  normal: 0

}
```

This would not, since the selected balls do not exist in the superstate above:

```ruby
{
  unknown: 0,
  possibly_lighter: 3,
  possibly_heavier: 0,
  normal: 0

}
```


#### Selection Superstate

This represents all the different ways you could possibly weigh a given state of balls (i.e. different combinations of marked balls you could put on either end of the scale). It is encoded as an array of **Complex Selection Orders**


#### Weigh Order

This is just a **Selection Superstate** where each **Complex Selection Orders** is mapped (via `:balls`) to an array representing all possible **Ball Arrangements**. For example, a single order in a **Weigh Order** would might look like this:


```ruby
{
  left: {
    unknown: 0,
    possibly_lighter: 1,
    possibly_heavier: 1,
    normal: 0
  },
  right: [
    {
      unknown: 2,
      possibly_lighter: 0,
      possibly_heavier: 0,
      normal: 0
    },
    {
      unknown: 0,
      possibly_lighter: 1,
      possibly_heavier: 1,
      normal: 0
    },
    {
      unknown: 1,
      possibly_lighter: 1,
      possibly_heavier: 0,
      normal: 0
    }
  ],
  balls: [ ... ]
}
```

#### Weighed Selections

This represents the outcome of actually weighing a **Weigh Order**, all possible selections are mapped to all the possible states that could result from having made a weigh according to them.

For instance, if I have three `:unknown` balls, the only possible selection is to weigh one `:unknown` ball on each side. The results of weighing according to this selection could be one `:possibly_lighter` ball, one `:possibly_heavier` and one `:normal` (if the scale's don't balance) or two `:normal` balls and one `:unknown` (if they do).

These are encoded as an array of simple selections, each mapped to all the resulting states. A single **Weighed Selection** entry might look like this:

```ruby
{
  left: {
    unknown: 1,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  },
  right: {
    unknown: 1,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  },
  states: [
    {
      unknown: 2,
      possibly_lighter: 0,
      possibly_heavier: 0,
      normal: 2
    },
    {
      unknown: 0,
      possibly_lighter: 1,
      possibly_heavier: 1,
      normal: 2
    }
  ]
}
```

#### Weighed Selections, Rated

Exactly the same, but each selection and each associated state has been given a **Rating**.

#### Weighed Selections, Scored

Exactly the same as **Rated Weighed Selections**, but each selection is given a **Score**. Associated states are still rated but have no **Score**.
