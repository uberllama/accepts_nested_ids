# AcceptsNestedIds

## Conundrum:

You want to save associations (`has_many` or `has_many :through`) by ID, but Rails is totally not doing what you expect it to.

## Solution:

This gem.

## What the hell am I talking about?

Let's take a typical scenario.

```ruby
class Project < ActiveRecord::Base
  has_many :project_users
  has_many :users, through: :project_users
  validates :name, presence: true
end

class User < ActiveRecord::Base
  has_many :project_users
  has_many :projects, through: :project_users
end
```

When creating or updating a Project, you can select a list of User IDs from a select list. Great.

```ruby
project = Project.first
project.name = ""
project.user_ids = [1,2,3]
project.save!
```

Oh shit.

Thats right: Rails went ahead and associated those Users, even through the save failed. Because it didn't even wait until the `save!` to associate them. It happened right here: `project.user_ids = [1,2,3]`

No one wants this. But it happens all the time.

## Get to the point already

AcceptsNestedIds defers the saving of ID-based associations to a model's `after_save` callback. In the example above, no User associations would have been created.

## Bonus

Ever need audit trail functionality? Its easy, using ActiveModel::Dirty and its related methods (`changes?`, etc). However, what you won't get out-of-the-box is dirty tracking for associated attributes. Because why would you?

AcceptsNestedIds adds dirty tracking for ID-based associations:

```ruby
project = Project.first
project.user_ids = [1,2,3]
project.changes # => "user_ids" => [[], [1,2,3]]
```

Beauty.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'accepts_nested_ids'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install accepts_nested_ids

## Usage

### When your association is conventionally named:

```ruby
class Project < ActiveRecord::Base
  include AcceptsNestedIds
  has_many :project_users
  has_many :users, through: :project_users
  accepts_nested_ids_for :users
end
```

### When your association has a custom name:

```ruby
class Project < ActiveRecord::Base
  include AcceptsNestedIds
  has_many :project_users
  has_many :included_users, through: :project_users, source: :user
  accepts_nested_ids_for included_users: "User"
end
```

### Mix and match as desired:

```ruby
class Project < ActiveRecord::Base
  include AcceptsNestedIds
  has_many :documents
  has_many :project_users
  has_many :included_users, through: :project_users, source: :user
  accepts_nested_ids_for :documents, included_users: "User"
end
```

You can now comfortably set `document_ids` or `user_ids` on a `Project` without making a mess of things.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/littleblimp/accepts_nested_ids.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

