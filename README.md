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

This application uses Ruby 1.9.3 and Rails 4.0.2.

In `lib/sample_data/sample_data.rb` are all the scripts to
create the data to be used for each demonstrating function.

To create the CSV that will be used in the create method run
the following command from your rails console.

```ruby
SampleData.create_contacts_csv(10000, "contacts.csv", 1)
```

The first parameter is the amount, the second is the filename, and
the third is which user to associate the contacts with.

The CSV function uses the Faker gem to create the data for the
contacts.

After we run the create method we'll need to run another one
so that the categories and categorizations are set up for
Read, Update, and Delete.

### Create

### Read

### Update

### Delete
