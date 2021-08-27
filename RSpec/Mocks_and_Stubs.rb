# -------- Mocks and Stubs ---------------

# ---- Test Doubles ----

echo = double('echo')

expect(echo).to receive(:sound)

expect(echo).to receive(:sound).with("hey").and_return("hey")

# ---- Stubs ----

yodeler = double('yodeler', yodels?: true)

yodeler = double(Yodeler, yodels?: true)

# ---- Null Objects ----

null_object = double('null').as_null_object

# ---- Partial Mocking and Stubbing ----

allow(invoice).to receive(:billed_expenses).and_return(543.21)

mocks.verify_partial_doubles = true

# ---- receive_message_chain ----

allow(BlogPost)
  .to receive_message_chain(:recent, :unpublished, :chronological)
  .and_return([double, double, double])

