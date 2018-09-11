# Quickfilter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quickfilter', git: 'https://github.com/rcpedro/quickfilter.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quickfilter

## Usage

Given the models:

```ruby
class ApplicationRecord < ActiveRecord::Base
  include Quickfilter
  self.abstract_class = true
end

class User < ApplicationRecord
  enum status: [:active, :inactive]
  
  has_many :students
  has_many :universities, through: :students

  has_one :current_student, -> { where(status: 'active') }, class_name: 'Student'
  has_one :current_university, through: :current_student, class_name: 'University'
end

class University < ApplicationRecord
  has_many :students
  has_many :users, through: :students
end

class Student < ApplicationRecord
  belongs_to :university
  belongs_to :user
end
```

### Basic Filter

Query using a set number of operators defined in `lib/quickfilter/handlers.rb`:

```ruby
User.filter(
  first_name: { likeic: 'jOhn' }, 
  status:     { in: [0, 1] },
  created_at: {
    gte: Date.today.beginning_of_month,
    lte: Date.today
  }
)
``` 

If the parameter for a filter is null, it is ignored and removed (since this is the case for most search forms wherein almost all parameters are optional). For example, the following are equivalent:

```ruby
User.filter(first_name: { likeic: nil })
User.filter({})
User.where(nil)
```

A special `isnull` filter which accepts `true` or `false` can be used to filter nulls.

### Filter with Joins

If another table is provided in the filter, the query builder will automatically do a join based on the table name:

```ruby
# Automatically joins University with User
University.filter(name: { eq: 'SLU' }, 
                  users: { first_name: { likeic: 'john' }})
```

However, if the parameter value is nil, the join is ommitted:

```ruby
# Automatically joins University with User
query = University.filter(name: { eq: 'SLU' }, 
                          users: { first_name: { likeic: nil }})

query.to_sql # will output "SELECT \"universities\".* FROM \"universities\" WHERE (universities.name = 'SLU')"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/quickfilter.

