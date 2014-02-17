## What to do When ActiveRecord, MySQL, and Your Data Betray You

This project is an example application to demonstrate the issues
I will be discussing in one-on-one pairing sessions at the
Big Ruby Conference held on Feb 20th - Feb 21, 2014 in
Dallas, TX.

The application goes through each CRUD function
- Create
- Read
- Update
- Delete

and gives an example for an "oh_crud" problem (which is a
dangerous or inefficient query) and a better optimized
query. Often we assume that ActiveRecord knows best. If we really
look at our queries we may discover that returned MySQL is not what
we intended at all.

Generally small amounts of data, 0-3000 records won't demonstrate
the problems well.I recommend using 10,000 or more records to really
see the problems with these queries. Some you may not want to actually
run because the server or MySQL may crash, but I'll go into
that specifically in each function.

We will go over each CRUD function and explore the consequences of
chaining, uses for Arel (A Relational Albegra) and even write
raw SQL statements. Some of the examples will be based soley on producing
faster queries, others will expore some assumptions we might make while
writing out ActiveRecord queries.

### Let's Make Some Data

This application uses Ruby 1.9.3 and Rails 4.0.2. Of course
`bundle install` and `rake db:migrate` must be run before
this will work.

`lib/sample_data/` contains all the scripts to
create the data to be used for each demonstrating function
and an example for each CRUD function.

To create the CSV that will be used in the create method run
the following command from your rails console.

```ruby
SampleDataSetup.create_contacts_csv(10000, "contacts.csv", 1)
```

The first parameter is the amount, the second is the filename, and
the third is which user to associate the contacts with.

The CSV function uses the Faker gem to create the data for the
contacts.

### Create

To create the contacts in the database first run the above CSV
creation command, it won't work without a file named contacts.csv.

The module demonstrates two creation methods. One that is uses the
standard create! while the other demonstrates MySQL's Batch Insert -
a function that is not available in ActiveRecord.

Let's run the oh_crud version.

```ruby
SampleDataCreate.create_contacts_oh_crud
```

This method runs through each row of the csv and creates the record:
```ruby
def self.create_contacts_oh_crud
  CSV.foreach("#{Rails.root}/lib/sample_data/contacts.csv", headers: true) do |csv|
    Contact.create!({
      :first_name => csv[0],
      :last_name => csv[1],
      :birthday => csv[2],
      ...
      :user_id => csv[24]
    })
  end
end
```

Now this method likely won't blow up with 10k records, but when you get
closer to 100k records your time starts to suffer and you could be
sitting there for hours waiting for it to finish.

This method produces the following SQL and benchmarks at:

```ruby
(0.2ms)  BEGIN
SQL (0.6ms)  INSERT INTO `contacts` (`address_1`, `address_2`, `birthday`, `city`, `company`, `company_address_1`, `company_address_2`, `company_city`, `company_country`, `company_postal_code`, `company_state`, `country`, `email`, `facebook_account_link`, `first_name`, `github_account_link`, `gplus_account_link`, `last_name`, `linkedin_account_link`, `phone`, `postal_code`, `state`, `title`, `twitter_account_link`, `user_id`) VALUES ('6186 Charles Viaduct', 'Apt. 583', '1987-02-01', 'North Danikachester', 'Hickle LLC', '8904 Titus Squares', 'Apt. 371', 'West Otto', 'USA', '60254-1949', 'ID', 'USA', 'lauretta.senger.0@example.com', 'http://www.facebook.com/lauretta_0_sample', 'Lauretta', 'http://www.github.com/lauretta_0_sample', 'http://gplus.google.com/posts/lauretta_0_sample', 'Senger', 'http://www.linkedin.com/in/lauretta_0_sample', '1-439-658-7097 x274', '22882', 'AL', 'District Mobility Technician', 'http://www.twitter.com/lauretta_0_sample', 1)
...

         user     system      total         real
=>  44.740000   1.180000  45.920000 ( 51.095556)
```

I didn't post all of the SQL, imagine it does that for all 10k records, one
at a time. Oof.

Now's let's delete that data and run the other create command.

```ruby
Contact.delete_all
SampleDataCreate.create_contacts_optimized
```

And if we measure the other create method as we run it:
```ruby
         user     system      total         real
=>   2.710000   0.050000   2.760000 (  3.227031)
```

WOW! That's a marked improvement. Now let's go over some
caveats of using the MySQL Batch Insert. The batch insert works
by inserting all the records at once.

**NOTE: MySQL Batch Insert will not fire callbacks since each object
is not instantiated and saved.**

Instead of creating and saving each record the batch insert does
exactly what it's name implies. There is no method in ActiveRecord
that does exactly this. Don't be scared to abandon AR in the case,
sometimes it's necessary and you're database will love you.

To get the batch insert working we'll start with an empty array. As
we read each line of the csv we will build an array of contact values.
We have to be very careful here to get the correct columns and that
quotes are being escaped correctly. For my project I only cared that there
weren't single quotes so I gsub'ed them out. You obviously can't do this
with real data, this is just a demonstration.

The array must be in quotes and surrounded by parentheses ex `"('data', 'data')"`.
We then decide on a batch size - this is because even MySQL can't handle 10k
records at once. After playing with a lot of different numbers I found that 2k
records was most reliable. We then shift those values in the while loop until it's
empty.

In the while loop we create the sql insert statement and join contacts_shifted
for the values. Connect to mysql and excute.

This seems really complicated and it's a bit tedious. You have to be sure the
values line up perfectly with the MySQL columns, but the savings are tremendous!

If you have a lot of data that needs to be created at once in MySQL, batch insert
will likely be your best bet.

Before we can continue we need to set up the relationships between contacts and
categories. These will be used later in the exercise and can be found in the
SampleDataSetup module. The way these relationships are created is for ease of
explanation and not the way it would be done in a live application. Simply run:
```ruby
SampleDataSetup.create_categories_and_relationships
```

### Read

Now that we have our data, let's read it. Let's say we want to get all of our
contacts first names. Generally we would run a simple each block on all contacts:

```ruby
SampleDataRead.read_contacts_oh_crud
```
which looks like this:
```ruby
def self.read_contacts_oh_crud
  Contact.where(:user_id => 1, :country => "USA").each do |contact|
    puts contact.first_name
  end
end
```
And it benchmarks at:
```
         user     system      total         real
=>   0.910000   0.050000   0.960000 (  0.997945)
```

Simple enough. Not slow at all, but let's see if we can't speed this up. Let's try
using `find_each` instead of `each`. `find_each` will collect the records in
batches of 1000. What's interesting though without the where if we were to just ask
for `Contact.all.each` turned out in Rails 4 to actually be a little faster than
`Contact.all.find_each`. When using where though MySQL must search the records
instead of just grabbing them all at once. Also as we increase records from say
10k to 100k the results will be very different.

So let's run the next method:
```ruby
SampleDataRead.read_contacts_optimized
```
which looks like:
```ruby
def self.read_contacts_optimized
  Contact.where(:user_id => 1, :country => "USA").find_each do |contact|
    puts contact.first_name
  end
end
```
This one actually benchmarks a tad higher the first time it's run:
```
        user     system      total         real
=>   0.910000   0.050000   0.960000 (  0.990555)
```

It's hard to see the savings here, it's almost negilble. Interestingly,
as the query becomes more complicated the savings are more and more
noticble. I actually found (contrary to the Rails docs) that `Contact.all.each`
ran faster than `Contact.all.find_each`.

So, let's look at the data we want. We're actually only outputting only one
column so why collect the entire record? There's an even faster way to
the entire record? Although this doesn't happen often we can grab just one
column with the `select` Arel clause:
```ruby
SampleDataRead.read_contacts_optimized_alt
```
which looks like:
```ruby
def self.read_contacts_optimized_alt
  Contact.where(:user_id => 1, :country => "USA").select(:first_name).each do |contact|
    puts contact.first_name
  end
end
```
and benchmarks at:
```
         user     system      total         real
=>   0.560000   0.040000   0.600000 (  0.620693)
```
This one makes it easier to actually see the improvement. With 100k
records this will save your database a LOT of time.

### Update

Oh no! We set all of our contacts to the wrong category! We need a quick way
to update all of them. We could go through each category and update them.
The following method will do this for us:

```ruby
category = Category.first
SampleDataupdate.update_contacts_oh_crud(category)
```

which becomes:
```ruby
def self.update_contacts_oh_crud(category)
  Categorization.all.each do |categorization|
    categorization.update_attributes(:category_id => category.id)
  end
end
```
But this is going to take a long time. It benchmarks at:
```
         user     system      total         real
=>  13.170000   1.280000  14.450000 ( 18.640788)
```

This takes so long because ActiveRecord instantiates and updates each individual
object before it updates it. But all the records are getting the same update so
maybe there is a better way that will update them all at once.

If we run this command:

```ruby
category = Category.where(:name => "Coworkers").first
SampleDataUpdate.update_contacts_optimized(category)
```
which is doing the following:

```ruby
def self.update_contacts_optimized(category)
  Categorization.update_all(:category_id => category.id)
end
```
and benchmarks it at:
```
         user     system      total         real
=>   0.000000   0.000000   0.000000 (  0.042140)
```

Instead of running through each object and updating them it produces
a one line udpate in SQL:
```
UPDATE `categorizations` SET `categorizations`.`category_id` = 15
```
which updates all the records at once.

This optimized method provides huge time savings for your queries.

### Delete

Now it's time to destroy records. Many developers would just run `destroy_all` on
the model and call it a day. But what if you want to destroy related records?
Associations with 10k records won't break MySQL but it will run slowly. With 100k
records though, I've killed MySQL. That's not great. We never want our queries to
be so overloading to the database that it just goes away. The problem with `destroy_all`
is like our update methods above instantiates each object.

For these examples I recommend running rails console in sandbox mode (`rails c -s`)
because then we can easily rollback our changes by exiting instead of re-running
the create command.

A destroy all might look like this:
```ruby
SampleDataDelete.destroy_contacts_oh_crud(category)
```

which will run:
```ruby
category.contacts.destroy_all
```
This will instantiate and delete each individual categorization record.
And it's benchmark demonstrates exactly how slow this is:
```
         user     system      total         real
=> 132.980000   0.370000 133.350000 (133.996548)
```

Now we could just change the query to:
```ruby
category.contacts.delete_all
```
That produces interesing SQL that I didn't expect the first time I
ran the same query:
```ruby
Contact Load (54.1ms)  SELECT `contacts`.* FROM `contacts` INNER JOIN `categorizations` ON `contacts`.`id` = `categorizations`.`contact_id` WHERE `categorizations`.`category_id` = 3
SQL (54.3ms)  DELETE FROM `categorizations` WHERE `categorizations`.`category_id` = 3 AND `categorizations`.`contact_id` IN (1, 2, 3, 4, 5, 6, 7, 8,...10000)
```

This is better because we aren't instantiating each object, but it's confusing to
other developers what we're trying to delete here.

Updating this to delete the categorization instead is a lot less
confusing, so we can run:
```ruby
category.categorizations.delete_all
```
It's faster but this isn't exactly what we want. If we look athe the SQL that is
produced we're going to wonder if there's an even faster way to run this query.
The first time I ran this I expected the following SQL to be produced:
```
DELETE FROM `categorizations` WHERE `categorizations`.`category_id` = 10
```
Now this is what we get if the relationship between category and categorizations is
not actually loaded. But since that's rarely the case here's what we actually get:
```
DELETE FROM `categorizations` WHERE `categorizations`.`category_id` = 10 AND `categorizations`.`id` IN (10001, 10002, 10003, 10004,...
```
Wat.

Definitely not what I would have expected. After dealing with these types of issues
at lot in the PhishMe application I decided it's better not to chain relationships
when deleting records.

The following example will show that deleting the object directly is faster, safer,
and actually produces the above expected SQL output:

If we run:
```ruby
SampleDataDelete.delete_categorizations_optimized(category)
```

which does:
```ruby
Categorization.where(:category_id => category.id).delete_all
```

and produces the following MySQL and benchmark:
```ruby
SQL (38.0ms)  DELETE FROM `categorizations` WHERE `categorizations`.`category_id` = 3
         user     system      total         real
=>   0.010000   0.000000   0.010000 (  0.043482)
```

The above is very clear what exactly we want from ActiveRecord and that we expect
all categorizations with the category id to be deleted.

Now what if we really did want to delete all contacts that belonged to a specific
category? Well there are lots of ways to do this but a simple join will be relatively
quick and also be super clear about our intentions like the above query.

If we run:
```ruby
SampleDataDelete.delete_contacts_optimized(category)
```
which performs:
```ruby
Contact.joins(:categorizations).where('categorizations.category_id' => category.id).delete_all
```
and is translated into MySQL and benchmarks at:
```ruby
SQL (2114.8ms)  DELETE FROM `contacts` WHERE `contacts`.`id` IN (SELECT id FROM (SELECT `contacts`.`id` FROM `contacts` INNER JOIN `categorizations` ON `categorizations`.`contact_id` = `contacts`.`id` WHERE `categorizations`.`category_id` = 3) __active_record_temp)
         user     system      total         real
=>   0.050000   0.010000   0.060000 (  2.170937)
```

All of these suggestions depend on your applications needs. It's important to keep
in mind that with `delete_all` will not fire callbacks so dependent associations will
not be deleted as expected.

It's important to keep in mind that we may be making assumptions about our query output
when using ActiveRecord. It's an amazing tool but there is a lot of magic behind the
scenes that can be detrmintal to your application if not used properly.
