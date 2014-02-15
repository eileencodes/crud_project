## What to do When ActiveRecord, MySQL, and Your Data Betray You

This project is an example application to demonstrate the issues
I will be discussing in one-on-one pairing sessions at the
Big Ruby Conference help on Feb 20th - Feb 21, 2014 in
Dallas, TX.

The application goes through each CRUD function
- Create
- Read
- Update
- Delete

and gives an example for an "oh\_crud" function (which is a
dangerous or inefficient query) and a better optimized
query. Generally small amounts of data, 0-3000 records
won't demonstrate the problems well.

I recommend using 10,000 or more records to really see the
problems with these queries. Some you may not want to actually
run because the server or MySQL may crash, but I'll go into
that specifically in each function.

### Let's Make Some Data

This application uses Ruby 1.9.3 and Rails 4.0.2. Of course
`bundle install` and `rake db:migrate` must be run before
this will work.

In `lib/sample_data/sample_data.rb` are all the scripts to
create the data to be used for each demonstrating function.

To create the CSV that will be used in the create method run
the following command from your rails console.

```ruby
SampleDataSetup.create_contacts_csv(10000, "contacts.csv", 1)
```

The first parameter is the amount, the second is the filename, and
the third is which user to associate the contacts with.

The CSV function uses the Faker gem to create the data for the
contacts.

After we run the create method we'll need to run another one
so that the categories and categorizations are set up for
Read, Update, and Delete.

### Create

To create the contacts in the database first run the above CSV
creation command, it won't work without a file named contacts.csv.

The module demonstrates two creation methods. One that is uses the
standard create! while the other demonstrates MySQL's Batch Insert -
a function that is not available in ActiveRecord.

Let's run the oh\_crud version.

```ruby
SampleDataCreate.create_contacts_oh_crud
```

Now this method likely won't blow up with 10k records, but when you get
closer to 100k records your time starts to suffer and you could be
sitting there for hours waiting for it to load.

If we run the method with the benchmark this will be the result:

```ruby
Benchmark.measure { SampleDataCreate.create_contacts_oh_crud }
         user     system      total         real
=>  44.740000   1.180000  45.920000 ( 51.095556)
```

Now's let's delete that data and run the other create command.
Alternatively you could be running the console in sandbox mode and
restart the console (`rails c -s`) which will rollback your changes.

```ruby
Contact.delete_all
SampleDataCreate.create_contacts_optimized
```

And if we measure the other create method as we run it:
```ruby
Benchmark.measure { SampleDataCreate.create_contacts_optimized }
         user     system      total         real
=>   2.710000   0.050000   2.760000 (  3.227031)
```

WOW! That's a marked improvement. Now let's go over some
caveats of using the MySQL Batch Insert. The batch insert works
by inserting all the records at once.

**NOTE: MySQL Batch Insert will not fire callbacks since each object
is not instantiated and saved.**

Instead of creating and saving each record the batch insert does
exactly what it's name implies. There is no comprable method in
ActiveRecord. Don't be scared to abandon AR, sometimes it's necessary
and you're database will love you.

To get the batch insert working we'll start with an empty array. As
we read each line of the csv we will build an array of contact values.
We have to be very careful here to get the correct columns and that
quotes are being escaped correctly. For my project I only cared that there
weren't single quotes so I gsub'ed them out. You obviously can't do this
with real data, this is just a demonstration.

The array must be in quotes and surrounded by parentheses ex `"('data', 'data')"`.
We then decide on a batch size - this is because even MySQL can't handle 10k
records at once. After playing with a lot of different numbers this is where I
found it to be most reliable, 2k records. We then shift those values in the while
loop until it's empty.

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
    Contact.where(:user_id => 1).each do |contact|
      puts contact.first_name
    end
  end
```
And it benchmarks at:
```
=>   0.920000   0.060000   0.980000 (  1.010865)
```

Simple enough. Not slow at all, but let's see if we can't speed this up. Let's try using `find\_each`
instead of `each`. `find\_each` will collect the records in batches of 1000. What's interesting though
without the where if we were to just ask for `Contact.all.each` turned out in Rails 4 to actually be
a little faster than `Contact.all.find\_each`. When using where though MySQL must search the records
instead of just grabbing them all at once. Also as we increase records from say 10k to 100k the results
will be very different.

So let's run the next method:
```ruby
SampleDataRead.read_contacts_optimized
```
which looks like:
```ruby
  def self.read_contacts_optimized
    Contact.where(:user_id => 1).find_each do |contact|
      puts contact.first_name
    end
  end
```
This one benchmarks at:
```
 =>   0.880000   0.050000   0.930000 (  0.963246)
```
Again, the small amount of data doesn't really show a drastic difference.
So, if we look at our query we're only getting one column, why collect
the entire record? Although this doesn't happen often we can grab just one
column with the `select` Arel clause:
```ruby
SampleDataRead.read_contacts_optimized_alt
```
which looks like:
```ruby
  def self.read_contacts_optimized_alt
    Contact.select(:first_name).each do |contact|
      puts contact.first_name
    end
  end
```
and benchmarks at:
```
=>   0.470000   0.040000   0.510000 (  0.520477)
```
This one makes it easier to actually see the improvement. With 100k
records this will save your database a LOT of time.

### Update

### Delete
